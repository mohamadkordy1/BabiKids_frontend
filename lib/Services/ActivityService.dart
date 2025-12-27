import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/Activity.dart';

class ActivityService {
  final Dio dio = DioClient.dio;

  /// 🔹 EXISTING METHOD (UNCHANGED)
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

  /// 🔹 NEW SAFE METHOD: Create Activity
  Future<Activity> createActivity({
    required String title,
    required String description,
    required int classroomId,
    required int createdBy,
  }) async {
    try {
      final response = await dio.post(
        '/activities',
        data: {
          "title": title,
          "description": description,
          "created_by": createdBy.toString(),
          "created_at":
          "${DateTime.now().day.toString().padLeft(2, '0')}-"
              "${DateTime.now().month.toString().padLeft(2, '0')}-"
              "${DateTime.now().year}",
          "classroom_id": classroomId.toString(),
        },
      );

      return Activity.fromJson(response.data['data']);
    } catch (e) {
      print('Failed to create activity: $e');
      rethrow; // Let the caller handle errors
    }
  }
}
