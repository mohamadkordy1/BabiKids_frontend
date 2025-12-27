import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Models/Classroom.dart';
import '../Core/Network/DioClient.dart';
import 'UserController.dart';
import 'package:frontend/Controllers/ClassroomController.dart';

class ClassroomController extends GetxController {
  var classrooms = <Classroom>[].obs;
  final UserController userController = Get.find<UserController>();

  // ------------------- Fetch Classes -------------------
  Future<void> fetchClassrooms() async {
    try {
      final response = await DioClient.dio.get(
        '/classrooms',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken.value}',
          },
        ),
      );

      final List data = response.data['data'];

      final currentTeacherName = userController.user.value?.name;

      final filtered = data
          .map((json) => Classroom.fromJson(json))
          .where((classroom) => classroom.teacher == currentTeacherName)
          .toList();

      classrooms.value = filtered;

      print("Loaded ${classrooms.length} classrooms for teacher");
    } catch (e) {
      print("Error fetching classrooms: $e");
    }
  }


  // ------------------- Create a New Class -------------------
  // ------------------- Create a New Class -------------------
  Future<bool> createClassroom({
    required String name,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await DioClient.dio.post(
        '/classrooms',
        data: {
          "name": name,
          "start_time": startTime,
          "end_time": endTime,
          "teacher_id": userController.user.value!.id,
          "activities_id": null,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken.value}',
          },
        ),
      );

      if (response.statusCode == 201) {
        final newClass =
        Classroom.fromJson(response.data['data']);
        classrooms.add(newClass);
        return true;
      }

      return false;
    } catch (e) {
      print("Error creating classroom: $e");
      return false;
    }
  }

// ------------------- Update Class -------------------
Future<bool> updateClassroom({
  required int classroomId,
  required String name,
  required String startTime,
  required String endTime,
}) async {
  try {
    final response = await DioClient.dio.put(
      '/classrooms/$classroomId',
      data: {
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "teacher_id": userController.user.value!.id,
        "activities_id": null,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${userController.accessToken.value}',
        },
      ),
    );

    if (response.statusCode == 200) {
      final updatedClass =
      Classroom.fromJson(response.data['data']);

      // Update local list safely
      final index =
      classrooms.indexWhere((c) => c.id == classroomId);
      if (index != -1) {
        classrooms[index] = updatedClass;
      }

      return true;
    }
    return false;
  } catch (e) {
    print("Error updating classroom: $e");
    return false;
  }
}
}