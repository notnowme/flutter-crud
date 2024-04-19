import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void refresh() {
    state++;
  }
}

final refreshProvier = NotifierProvider<RefreshNotifier, int>(() {
  return RefreshNotifier();
});
