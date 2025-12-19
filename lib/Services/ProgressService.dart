import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/Progress.dart';

class ProgressService {
  final Dio dio = DioClient.dio;

  Future<List<Progress>> fetchProgresses() async {
    final response = await dio.get('/progresses');

    return (response.data['data'] as List)
        .map((e) => Progress.fromJson(e))
        .toList();
  }
}
