import 'dart:async';

import 'package:crud/controllers/join_controller.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/models/login_model.dart';
import 'package:crud/providers/storage_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

final joinProvider =
    FutureProvider.autoDispose.family((ref, JoinModel info) async {
  try {
    return await JoinController().join(info);
  } catch (e) {
    throw Exception(e);
  }
});

final asyncJoinProvider = AsyncNotifierProvider<JoinAsyncNotifier, void>(() {
  return JoinAsyncNotifier();
});

class JoinAsyncNotifier extends AsyncNotifier<void> {
  late final JoinController _auth;
  late Map<String, dynamic> formData;
  late Map<String, dynamic>? resultData;
  late final FlutterSecureStorage storage;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  FutureOr<void> build() async {
    _auth = ref.read(authController);
    formData = {
      'id': '',
      'nick': '',
      'password': '',
    };
    resultData = {};
    storage = ref.read(secureStorageProvider);
  }

  FutureOr<bool> checkId(String id) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _auth.idCheck(id);
    });

    if (state.hasError) {
      return false;
    }
    return true;
  }

  FutureOr<bool> checkNick(String nick) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _auth.nickCheck(nick);
    });
    if (state.hasError) {
      return false;
    }
    return true;
  }

  FutureOr<bool> join(JoinModel user) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _auth.join(user);
    });

    if (state.hasError) {
      DioException err = state.error as DioException;
      print(err.response?.data['message']);

      return false;
    }
    return true;
  }

  Map<String, dynamic>? getData() {
    return resultData;
  }

  FutureOr<bool> login(LoginModel user) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      resultData = await _auth.login(user);
    });

    if (state.hasError) {
      DioException err = state.error as DioException;
      if (err.response?.statusCode == 401) {
        showToast('비밀번호가 틀렸어요');
        resultData = {
          'code': 401,
        };
        return false;
      }
      if (err.response?.statusCode == 404) {
        showToast('없는 아이디예요');
        resultData = {
          'code': 404,
        };
        return false;
      }
      return false;
    }
    Future.wait(
      [
        storage.write(
          key: 'accessToken',
          value: resultData!['data']['token'],
        ),
        storage.write(
          key: 'id',
          value: resultData!['data']['id'],
        ),
        storage.write(
          key: 'nick',
          value: resultData!['data']['nick'],
        ),
      ],
    );
    return true;
  }

  FutureOr<bool> changeNick(String nick) async {
    final userData = ref.watch(userProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      resultData = await _auth.changeNick(nick, userData!['accessToken']);
    });

    if (state.hasError) {
      DioException err = state.error as DioException;
      if (err.response?.statusCode == 409) {
        showToast('다시 로그인해 주세요');
        await storage.deleteAll();
        resultData = {
          'code': 401,
        };
        return false;
      }
      if (err.response?.statusCode == 409) {
        showToast('이미 있는 닉네임이에요');
        resultData = {
          'code': 409,
        };
        return false;
      }
      return false;
    }
    await storage.write(key: 'nick', value: resultData!['data']['nick']);
    showToast('변경했어요!');
    return true;
  }

  void setId(String? id) {
    formData['id'] = id;
  }

  void setNick(String? nick) {
    formData['nick'] = nick;
  }
}

final idCheckProvider = NotifierProvider<IdCheckNotifier, bool>(() {
  return IdCheckNotifier();
});

class IdCheckNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> check(String id) async {
    try {
      final result = await JoinController().idCheck(id);
      if (result['ok']) {
        state = true;
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
  }
}

final nickCheckProvider = NotifierProvider<NickCheckNotifier, bool>(() {
  return NickCheckNotifier();
});

class NickCheckNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> check(String nick) async {
    try {
      final result = await JoinController().nickCheck(nick);
      if (result['ok']) {
        state = true;
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
  }
}
