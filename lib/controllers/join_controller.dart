import 'package:crud/services/dio_service.dart';
import 'package:dio/dio.dart';

class JoinController {
  final Dio _dio = DioService().to();

  Future<Map<String, dynamic>> join(Map<String, dynamic> info) async {
    try {
      final res = await _dio.post(
        'auth/local/join',
        data: info,
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
}
