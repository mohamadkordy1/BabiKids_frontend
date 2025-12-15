import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../Models/Report.dart';
import 'UserController.dart';

class ReportController extends GetxController {
  var reports = <Report>[].obs;
  final UserController userController = Get.find<UserController>();

  // Fetch all reports
  Future<void> fetchReports() async {
    try {
      final response = await Dio().get(
        'http://babikids.test/api/v1/reports',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken.value}',
          },
        ),
      );

      final List data = response.data['data'];
      reports.value = data.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching reports: $e");
    }
  }

  // Fetch author name by user ID
  Future<String> getAuthorName(int userId) async {
    try {
      final response = await Dio().get(
        'http://babikids.test/api/v1/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken.value}',
          },
        ),
      );
      final data = response.data['data'];
      return data['name'] ?? 'Unknown';
    } catch (e) {
      print("Error fetching author: $e");
      return 'Unknown';
    }
  }
}
