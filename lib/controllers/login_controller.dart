import 'package:crud/services/dio_service.dart';
import 'package:dio/dio.dart';

class LoginController {
  final Dio _dio = DioService().to();
}
