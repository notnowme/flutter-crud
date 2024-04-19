import 'dart:convert';

import 'package:crud/models/free_contentDetailModel.dart';
import 'package:crud/models/free_contentModel.dart';
import 'package:crud/models/free_writeCommentModel.dart';
import 'package:crud/models/free_writeModel.dart';
import 'package:crud/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FreeController {
  final Dio _dio = DioService().to();

  Future<Map<String, dynamic>?> write(
      FreeWriteModel board, String token) async {
    try {
      final data = board.toJson();
      final res = await _dio.post(
        'board/free',
        data: data,
        options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: {
              'Authorization': token,
            }),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> writeComment(
      FreeWriteCommentModel board, String token) async {
    try {
      final data = board.toJson();
      final res = await _dio.post(
        'comment/free',
        data: data,
        options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: {
              'Authorization': token,
            }),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<List<FreeContentModel>?> getBoards() async {
    try {
      final res = await _dio.get('board/free?page=1');
      final result = res.data;
      // final contents = jsonDecode(result['data']);
      List<FreeContentModel> boards = [];
      for (final content in result['data']) {
        boards.add(FreeContentModel.fromJson(content));
      }
      return boards;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<FreeContentDetailModel?> getBoard(String no) async {
    try {
      final res = await _dio.get('board/free/$no');
      final result = res.data;
      final detail = FreeContentDetailModel.fromJson(result['data']);
      return detail;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }
}

final freeController = Provider((ref) => FreeController());
