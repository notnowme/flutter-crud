import 'dart:async';

import 'package:crud/controllers/join_controller.dart';
import 'package:crud/models/join_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  FutureOr<void> build() async {
    _auth = ref.read(authController);
    formData = {
      'id': '',
      'nick': '',
      'password': '',
    };
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
