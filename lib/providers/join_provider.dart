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
