import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Views/Teacher/ClassroomChildren/Progress/EditProgressTable.dart';
import '../../../Models/Classroom.dart';
import '../../../Models/Child.dart';
import 'package:frontend/Models/Progress.dart' as model;

import '../../../Controllers/UserController.dart';
import '../../../Controllers/ProgressController.dart';
import '../../../Core/Network/DioClient.dart';

import 'ClassroomChildren/Add_RemChild/AddChild.dart';
import 'ClassroomChildren/Add_RemChild/RemoveChild.dart';
import 'ClassroomChildren/Attendance/AttendanceDatePage.dart';
import 'ClassroomChildren/Activity/class_activities.dart';
import 'ClassroomChildren/ChildDetails.dart';
import 'ClassroomChildren/EditClassroom.dart';
import 'ClassroomChildren/Progress/Progress.dart';
import 'navbar.dart';

// ... imports remain the same ...

class ClassDetailsPage extends StatelessWidget {
  final Classroom classroom;

  ClassDetailsPage({super.key, required this.classroom});

  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color primary = Color(0xFF3B82F6);

  final RxList<Child> classroomChildren = <Child>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool showProgress = false.obs;

  final ProgressController progressController =
  Get.put(ProgressController());

  @override
  Widget build(BuildContext context) {
    fetchClassroomChildren();
    progressController.loadProgressForClass(classroom.id);

    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Obx(() {
          if (isLoading.value || progressController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          classroom.name,
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Start at ${classroom.startTime}, End at ${classroom.endTime}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 24),

              // ACTION BUTTONS
              _actionButton(Icons.add_circle, () {
                Get.to(() => AddExistingChildPage(classroom: classroom));
              }, "Add New Child", primary),
              _actionButton(Icons.remove_circle, () {
                Get.to(() => RemoveChildPage(classroom: classroom));
              }, "Remove Child", Colors.red),
              _actionButton(Icons.checklist, () {
                Get.to(() => AttendanceDatePage(classroom: classroom));
              }, "Attendance", Colors.green),
              _actionButton(Icons.local_activity, () {
                Get.to(() => ClassActivitiesPage(classroom: classroom));
              }, "Activity", Colors.teal),
              _actionButton(Icons.edit, () {
                Get.to(() => EditClassRoomPage(classroom: classroom));
              }, "Edit Class Details", Colors.deepPurple),
              _actionButton(Icons.task_alt, () {
                Get.to(() => CreateProgressPage(classroom: classroom));
              }, "Create Progress", Colors.orangeAccent),



              // SHOW / HIDE PROGRESS BUTTON
              _actionButton(Icons.task_alt, () => showProgress.toggle(),
                  showProgress.value ? "Hide Progress" : "Show Progress", primary),

              // PROGRESS SECTION WITH MATCHING PADDING
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ConstrainedBox(
                  constraints: showProgress.value
                      ? const BoxConstraints()
                      : const BoxConstraints(maxHeight: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (progressController.progresses.isEmpty)
                          const Text(
                            "No progress added for this class yet",
                            style: TextStyle(color: Colors.white70),
                          )
                        else
                          ...progressController.progresses
                              .map((p) => progressCard(p))
                              .toList(),
                      ],
                    ),
                  ),
                ),
              ),

              // CHILDREN SECTION
              Text(
                "Enrolled Children (${classroomChildren.length})",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              if (classroomChildren.isEmpty)
                const Text(
                  "No children found",
                  style: TextStyle(color: Colors.white70),
                )
              else
                ...classroomChildren.map((child) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ChildDetailsPage(child: child, classroom: classroom));
                    },
                    child: _ChildTile(
                      name: child.name,
                      level: child.gender,
                    ),
                  );
                }).toList(),

              const SizedBox(height: 40),
            ],
          );
        }),
      ),
    );
  }

  // BUTTON
  Widget _actionButton(
      IconData icon, Function f, String text, Color color,
      {Color textColor = Colors.white}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => f(),
        icon: Icon(icon, color: textColor),
        label: Text(text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  // FETCH CHILDREN
  Future<void> fetchClassroomChildren() async {
    try {
      isLoading.value = true;
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.get(
        '/classrooms/${classroom.id}/children',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data['children'];
      classroomChildren.value = data is List
          ? data.map((e) => Child.fromJson(e)).toList()
          : [];
    } finally {
      isLoading.value = false;
    }
  }
}

// ================= PROGRESS CARD WITH STATUS AND EDIT BUTTON =================
Widget progressCard(model.Progress p) {
  // Determine status color
  Color statusColor;
  String statusText;

  switch (p.status.toLowerCase()) {
    case 'completed':
      statusColor = Colors.green;
      statusText = 'Completed';
      break;
    case 'in-progress':
      statusColor = Colors.blue;
      statusText = 'In Progress';
      break;
    default:
      statusColor = Colors.grey;
      statusText = 'Unknown';
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                p.goalTitle,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => EditProgressPage(progress: p));
              },
              icon: const Icon(Icons.edit, color: Colors.orangeAccent),
              tooltip: "Edit Progress",
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text("Start: ${p.startDate}", style: const TextStyle(color: Colors.white70)),
        Text("Target: ${p.targetDate}", style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Text(p.notes, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}



// CHILD TILE
class _ChildTile extends StatelessWidget {
  final String name;
  final String level;

  const _ChildTile({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
            child: Text(name[0],
                style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
