import 'package:flutter_riverpod/flutter_riverpod.dart';

class PathNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void updatePrevPath(String path) {
    state = path;
  }
}

final pathProvider = NotifierProvider<PathNotifier, String>(() {
  return PathNotifier();
});
