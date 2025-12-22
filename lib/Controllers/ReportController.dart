import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../Models/Report.dart';
import 'UserController.dart';
import 'ChildrenController.dart';
class ReportController extends GetxController {
  var reports = <Report>[].obs;
  final UserController userController = Get.find<UserController>();
  final ChildrenController childrenController = Get.find<ChildrenController>();

  // Fetch all reports, then filter to only children belonging to this parent
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
      final allReports = data.map((json) => Report.fromJson(json)).toList();

      // Filter reports for this parent's children
      final parentChildIds = childrenController.children.map((c) => c.id).toSet();
      reports.value = allReports.where((report) => parentChildIds.contains(report.childId)).toList();

      print("Loaded ${reports.length} reports for parent ${userController.user.value?.name}");
    } catch (e) {
      print("Error fetching reports: $e");
    }
  }

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
