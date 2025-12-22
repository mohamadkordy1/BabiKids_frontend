import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/Activity.dart';

class ActivityService {
  final Dio dio = DioClient.dio;

  Future<List<Activity>> fetchActivities() async {
    try {
      final response = await dio.get('/activities');

      return (response.data['data'] as List)
          .map((e) => Activity.fromJson(e))
          .toList();
    } catch (e) {
      print('Failed to fetch activities: $e');
      return [];
    }
  }
}
