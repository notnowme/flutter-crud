import 'package:crud/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  Future<void> init() async {
    final storage = ref.read(secureStorageProvider);
    final data = await storage.readAll();
    if (data.isNotEmpty) {
      state = {
        'id': data['id'],
        'nick': data['nick'],
        'accessToken': data['accessToken'],
      };
    }
  }

  void clear() async {
    state = null;
  }
}

final userProvider = NotifierProvider<UserNotifier, Map<String, dynamic>?>(() {
  return UserNotifier();
});
