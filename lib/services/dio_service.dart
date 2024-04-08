import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  Map<String, dynamic> dioInformation = {};

  static Dio _dio = Dio();

  DioService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://10.0.2.2:4000/api/',
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
    );
    _dio = Dio(options);
  }

  Dio to() {
    return _dio;
  }
}
