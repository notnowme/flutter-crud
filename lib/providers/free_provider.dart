import 'dart:async';

import 'package:crud/controllers/free_controller.dart';
import 'package:crud/models/free_contentDetailModel.dart';
import 'package:crud/models/free_contentModel.dart';
import 'package:crud/models/free_writeCommentModel.dart';
import 'package:crud/models/free_writeModel.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final freeContentProvider =
    FutureProvider.autoDispose<List<FreeContentModel>?>((ref) async {
  final freeBoard = ref.read(freeController);
  final result = await freeBoard.getBoards();
  return result;
});

final freeOneContentProvider = FutureProvider.autoDispose
    .family<FreeContentDetailModel?, String>((ref, String no) async {
  final freeBoard = ref.read(freeController);
  final result = await freeBoard.getBoard(no);
  return result;
});

class FreeContentAsyncNotifier extends AsyncNotifier<List<FreeContentModel>?> {
  late final FreeController _freeBoard;
  late List<FreeContentModel>? boards;
  @override
  List<FreeContentModel>? build() {
    _freeBoard = ref.read(freeController);
    boards = null;
    return [];
  }

  Future<List<FreeContentModel>?> getBoards() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      boards = await _freeBoard.getBoards();
      return null;
    });

    if (state.hasError) {
      return null;
    }
    return boards;
  }
}

class FreeAsyncNotifier extends AsyncNotifier<void> {
  late final FreeController _freeBoard;
  late Map<String, dynamic> formData;
  late Map<String, dynamic>? resultData;

  @override
  void build() {
    _freeBoard = ref.read(freeController);
    formData = {};
    resultData = {};
  }

  void setFormData(String title, String content) {
    formData = {
      'title': title,
      'content': content,
    };
  }

  void setCmtFormData(String boardNo, String content) {
    formData = {
      'boardNo': boardNo,
      'content': content,
    };
  }

  void clearFormData() {
    formData = {};
  }

  Map<String, dynamic>? getData() {
    return resultData;
  }

  FutureOr<bool> write() async {
    final userData = ref.watch(userProvider);
    FreeWriteModel board = FreeWriteModel(
      title: formData['title'],
      content: formData['content'],
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      resultData = await _freeBoard.write(board, userData!['accessToken']);
    });

    if (state.hasError) {
      return false;
    }
    return true;
  }

  FutureOr<bool> writeComment() async {
    final userData = ref.watch(userProvider);
    FreeWriteCommentModel board = FreeWriteCommentModel(
      boardNo: formData['boardNo'],
      content: formData['content'],
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _freeBoard.writeComment(board, userData!['accessToken']);
    });

    if (state.hasError) {
      return false;
    }
    return true;
  }
}

final freeAsyncProvider = AsyncNotifierProvider<FreeAsyncNotifier, void>(() {
  return FreeAsyncNotifier();
});

final freeContentAsyncProvider =
    AsyncNotifierProvider<FreeContentAsyncNotifier, List<FreeContentModel>?>(
        () {
  return FreeContentAsyncNotifier();
});
