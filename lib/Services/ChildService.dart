import 'dart:convert';
import 'package:dio/dio.dart';
import '../Models/Child.dart';
import '../Models/Classroom.dart';
import '../Core/Network/DioClient.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:get/get.dart';

class ChildService {
  static Future<List<Child>> getChildren() async {
    try {
      final userController = Get.find<UserController>();
      final token = userController.accessToken.value;
      final dio = DioClient.dio;

      final response =await dio.get('/children');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Child.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load children. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching children: $e');
    }
  }

  static Future<List<Classroom>> getChildClassrooms(int childId) async {
    try {
      final userController = Get.find<UserController>();
      final token = userController.accessToken.value;
      final dio = DioClient.dio;
      final response =       await dio.get('/children/$childId/classrooms');


      if (response.statusCode == 200) {
        final classroomsData = response.data['classrooms'] as List;
        return classroomsData.map((json) => Classroom.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load classrooms. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching classrooms: $e');
    }
  }
}
