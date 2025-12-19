import 'dart:convert';
import 'package:frontend/Core/Network/DioClient.dart';
import '../Models/Report.dart';
import 'package:get/get.dart';
import '../Controllers/UserController.dart';
import 'package:dio/dio.dart';

class ReportService {
  static Future<List<Report>> getReports() async {
    try {
      final userController = Get.find<UserController>();
      final dio = DioClient.dio;

      final response =  await dio.get('/reports');

      final dataJson = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (dataJson != null && dataJson['data'] != null) {
        final List dataList = dataJson['data'];
        return dataList.map((json) => Report.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print("Error fetching reports: $e");
      return [];
    }
  }
}
