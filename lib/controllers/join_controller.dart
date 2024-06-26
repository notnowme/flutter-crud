import 'dart:async';

import 'package:crud/models/join_model.dart';
import 'package:crud/models/login_model.dart';
import 'package:crud/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinController {
  final Dio _dio = DioService().to();

  Future<Map<String, dynamic>> idCheck(String id) async {
    try {
      final data = {'id': id};
      final res = await _dio.post(
        'auth/check/id',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> nickCheck(String nick) async {
    try {
      final data = {'nick': nick};
      final res = await _dio.post(
        'auth/check/nick',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> join(JoinModel user) async {
    try {
      final data = user.toJson();
      final res = await _dio.post(
        'auth/local/join',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> login(LoginModel user) async {
    try {
      final data = user.toJson();
      final res = await _dio.post(
        'auth/login',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> changeNick(String nick, String token) async {
    try {
      final data = {
        'nick': nick,
      };
      final res = await _dio.patch(
        'users',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': token,
          },
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> checkPassword(LoginModel user) async {
    try {
      final data = user.toJson();
      final res = await _dio.post(
        'auth/check/password',
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> withdraw(String token) async {
    try {
      final res = await _dio.post(
        'auth/local/withdraw',
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': token,
          },
          responseType: ResponseType.json,
        ),
      );
      final result = res.data;
      print(result);
      return result;
    } catch (e) {
      if (e is DioException) rethrow;
    }
    return null;
  }
}

final authController = Provider((ref) => JoinController());
