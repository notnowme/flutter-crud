import 'package:crud/controllers/join_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final joinProvider =
    AutoDisposeFutureProviderFamily((ref, Map<String, dynamic> info) {
  try {
    return JoinController().join(info);
  } catch (e) {
    throw Exception(e);
  }
});

final idCheckProvider = NotifierProvider<IdCheckNotifier, bool>(() {
  return IdCheckNotifier();
});

class IdCheckNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> check(String id) async {
    final result = await JoinController().idCheck(id);
    print(result);
    if (result['ok']) {
      state = true;
    } else {
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
    final result = await JoinController().nickCheck(nick);
    print(result);
    if (result['ok']) {
      state = true;
    } else {
      state = false;
    }
  }
}
