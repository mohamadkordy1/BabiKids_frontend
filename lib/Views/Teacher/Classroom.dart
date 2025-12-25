import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Models/Classroom.dart';
import '../../../Models/Child.dart';
import '../../../Controllers/UserController.dart';
import '../../../Core/Network/DioClient.dart';
import 'ClassroomChildren/AddChild.dart';
import 'ClassroomChildren/RemoveChild.dart';
import 'ClassroomChildren/Attendance/AttendanceDatePage.dart';
import 'ClassroomChildren/class_activities.dart';
import 'ClassroomChildren/EditClassroom.dart';
import 'navbar.dart';
import 'package:dio/dio.dart';

class ClassDetailsPage extends StatelessWidget {
  final Classroom classroom;

  ClassDetailsPage({super.key, required this.classroom});

  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color primary = Color(0xFF3B82F6);

  final RxList<Child> classroomChildren = <Child>[].obs;
  final isLoading = true.obs;

  @override
  Widget build(BuildContext context) {
    // Fetch classroom children
    fetchClassroomChildren();

    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                          "Start at ${classroom.startTime} ,End at ${classroom.endTime}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _actionButton(Icons.add_circle, () {
                    Get.to(() => AddExistingChildPage(classroom: classroom));
                  }, "Add New Child", primary),
                  _actionButton(Icons.remove_circle, () {
                    Get.to(() => RemoveChildPage(classroom: classroom,));
                  }, "Remove Child", Colors.red),
                  _actionButton(Icons.checklist, () {
                    Get.to(() => AttendanceDatePage(classroom: classroom,));
                  }, "Attendance", Colors.green),
                  _actionButton(Icons.local_activity, () {
                    Get.to(() => ClassActivitiesPage());
                  }, "Activity", cardDark, textColor: primary),
                  _actionButton(Icons.edit, () {
                    Get.to(() => EditClassPage());
                  }, "Edit Class Details", cardDark, textColor: primary),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Text(
                  "Enrolled Children (${classroomChildren.length})",
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),

            // Children list
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (classroomChildren.isEmpty) {
                  return const Center(
                    child: Text("No children found", style: TextStyle(color: Colors.white)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: classroomChildren.length,
                  itemBuilder: (context, index) {
                    final child = classroomChildren[index];
                    return _ChildTile(name: child.name, level: child.gender);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      IconData icon, Function f, String text, Color color,
      {Color textColor = Colors.white}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => f(),
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Future<void> fetchClassroomChildren() async {
    try {
      isLoading.value = true;
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.get(
        '/classrooms/${classroom.id}/children',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data['children'];
      if (data != null && data is List) {
        classroomChildren.value = data.map((e) => Child.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        classroomChildren.clear();
        print("No children found or unexpected response: ${response.data}");
      }
    } catch (e) {
      print("Error fetching classroom children: $e");
      Get.snackbar("Error", "Failed to load classroom children",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

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
            child: Text(
              name.isNotEmpty ? name[0] : "?",
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  level,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}
