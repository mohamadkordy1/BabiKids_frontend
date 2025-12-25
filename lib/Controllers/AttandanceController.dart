import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/Attandace.dart';
import 'UserController.dart';class AttendanceController extends GetxController {
  var attendances = <Attendance>[].obs;
  var isLoading = false.obs;

  // 🔹 Selected month & year (default = current)
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  Future<void> fetchAttendance({
    required int classroomId,
    required int childId,
  }) async {
    try {
      isLoading.value = true;

      final userController = Get.find<UserController>();
      final dio = DioClient.dio;

      final response = await dio.get('/attendance');

      print("Attendance API response: ${response.data}");

      final List data = response.data['data'];

      attendances.value = data
          .map((e) => Attendance.fromJson(e))
          .where((a) =>
      a.classroomId == classroomId &&
          a.childId == childId)
          .toList();

    } catch (e) {
      print("Failed to load attendance: $e");
    } finally {
      isLoading.value = false;
    }
  }
  bool attendanceExistsForDate({
    required int classroomId,
    required String date,
  }) {
    return attendances.any(
          (a) =>
      a.classroomId == classroomId &&
          a.date == date,
    );
  }

  // 🔹 CHANGE MONTH/YEAR (NO API CALL)
  void changeMonthYear(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
  }

  // 🔹 FILTERED ATTENDANCE (MAGIC HERE)
  List<Attendance> get filteredAttendances {
    return attendances.where((a) =>
    a.month == selectedMonth.value &&
        a.year == selectedYear.value
    ).toList();
  }

  bool isPresent(int day) {
    return filteredAttendances.any(
          (a) => a.day == day && a.status == 'present',
    );
  }

  double presentPercentage(int totalDays) {
    if (filteredAttendances.isEmpty) return 0;
    final present = filteredAttendances
        .where((a) => a.status == 'present')
        .length;
    return (present / totalDays) * 100;
  }
}
