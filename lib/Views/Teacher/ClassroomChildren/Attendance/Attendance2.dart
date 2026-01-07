import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Models/Child.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:frontend/Core/Network/DioClient.dart';

import 'package:frontend/Controllers/AttandanceController.dart';

class DailyAttendancePage extends StatefulWidget {
  final DateTime selectedDate;
  final Classroom classroom;

  const DailyAttendancePage({
    super.key,
    required this.selectedDate,
    required this.classroom,
  });

  @override
  State<DailyAttendancePage> createState() => _DailyAttendancePageState();
}

class _DailyAttendancePageState extends State<DailyAttendancePage> {
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color primary = Color(0xFF3B82F6);
  static const Color presentColor = Color(0xFF22C55E);
  static const Color absentColor = Color(0xFFEF4444);

  final RxList<Child> children = <Child>[].obs;
  final RxBool isLoading = true.obs;

  /// childId -> true (present) / false (absent)
  final Map<int, bool> attendance = {};
  bool alreadySaved = false;


  @override
  void initState() {
    super.initState();
    final AttendanceController attendanceController =
    Get.put(AttendanceController());

    fetchClassroomChildren().then((_) async {
      // 🔴 IMPORTANT: fetch attendance FIRST
      await attendanceController.fetchAttendance(
        classroomId: widget.classroom.id,
        childId: children.isNotEmpty ? children.first.id : 0,
      );

      alreadySaved = attendanceController.attendanceExistsForDate(
        classroomId: widget.classroom.id,
        date: _formatDate(widget.selectedDate),
      );

      setState(() {});
    });
  }



  Future<void> fetchClassroomChildren() async {
    try {
      isLoading.value = true;
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.get(
        '/classrooms/${widget.classroom.id}/children',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data['children'];
      if (data != null && data is List) {
        children.value =
            data.map((e) => Child.fromJson(e as Map<String, dynamic>)).toList();

        // Initialize attendance map: all present by default
        for (final child in children) {
          attendance[child.id] = true;
        }
      } else {
        children.clear();
      }
    } catch (e) {
      print("Error fetching children: $e");
      Get.snackbar("Error", "Failed to load classroom children",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 1,
        title: Text(
          "Attendance",
          style: GoogleFonts.manrope(fontWeight: FontWeight.bold,color: Colors.white),

        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            // DATE DISPLAY
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _formatDate(widget.selectedDate),
                style: GoogleFonts.manrope(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            // CHILDREN LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  final isPresent = attendance[child.id] ?? true;

                  return _AttendanceCard(
                    name: child.name,
                    isPresent: isPresent,
                    onPresent: () => setState(() {
                      attendance[child.id] = true;
                    }),
                    onAbsent: () => setState(() {
                      attendance[child.id] = false;
                    }),
                  );
                },
              ),
            ),

            // SAVE BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: alreadySaved ? null : _saveAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alreadySaved ? Colors.grey : primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    alreadySaved ? "Attendance Already Saved" : "Save Attendance",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  Future<void> _saveAttendance() async {
    final token = Get.find<UserController>().accessToken.value;


    if (alreadySaved) {
      Get.snackbar(
        "Not Allowed",
        "Attendance for this date is already saved",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }



    try {
      for (final child in children) {
        final status = (attendance[child.id] ?? true) ? "present" : "absent";

        final body = {
          "class_id": widget.classroom.id.toString(),
          "child_id": child.id.toString(),
          "date": _formatDate(widget.selectedDate),
          "status": status,
          "check_in_time": "", // optional
          "check_out_time": "", // optional
          "classroom_id": widget.classroom.id.toString(),
        };

        await DioClient.dio.post(
          '/attendance',
          data: body,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );
      }

      Get.snackbar(
        "Success",
        "Attendance saved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Failed to save attendance: $e");
      Get.snackbar(
        "Error",
        "Failed to save attendance",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }setState(() {
      alreadySaved = true;
    });

  }
}

// Attendance Card
class _AttendanceCard extends StatelessWidget {
  final String name;
  final bool isPresent;
  final VoidCallback onPresent;
  final VoidCallback onAbsent;

  const _AttendanceCard({
    required this.name,
    required this.isPresent,
    required this.onPresent,
    required this.onAbsent,
  });

  static const Color cardDark = Color(0xFF1F2937);
  static const Color presentColor = Color(0xFF22C55E);
  static const Color absentColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.split(' ').map((e) => e[0]).take(2).join()
        : "?";


    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatusButton(
                label: "Absent",
                color: absentColor,
                selected: !isPresent,
                onTap: onAbsent,
              ),
              _StatusButton(
                label: "Present",
                color: presentColor,
                selected: isPresent,
                onTap: onPresent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
