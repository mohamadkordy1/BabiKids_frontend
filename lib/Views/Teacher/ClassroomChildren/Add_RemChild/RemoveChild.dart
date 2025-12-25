import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Models/Classroom.dart';
import '../../../Models/Child.dart';
import '../../../Controllers/UserController.dart';
import '../../../Core/Network/DioClient.dart';
import '../navbar.dart';
import 'package:dio/dio.dart';

class RemoveChildPage extends StatelessWidget {
  final Classroom classroom;
  RemoveChildPage({super.key, required this.classroom});

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color danger = Color(0xFFEF4444);

  final RxList<Child> classroomChildren = <Child>[].obs;
  final isLoading = true.obs;

  @override
  Widget build(BuildContext context) {
    // Fetch children of the classroom
    fetchClassroomChildren();

    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
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
                    child: Text(
                      "Remove Child",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for a child...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primary),
                  ),
                ),
                onChanged: (query) {
                  // Optional: implement search filtering
                },
              ),
            ),

            const SizedBox(height: 16),

            // Children List
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
                    return _RemoveChildTile(
                      child: child,
                      classroomId: classroom.id,
                      onRemoved: () {
                        classroomChildren.removeAt(index);
                      },
                    );
                  },
                );
              }),
            ),
          ],
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
        classroomChildren.value = data.map((e) => Child.fromJson(e)).toList();
      } else {
        classroomChildren.clear();
        print("No children found or unexpected response: ${response.data}");
      }
    } catch (e) {
      print("Error fetching classroom children: $e");
      Get.snackbar(
        "Error",
        "Failed to load classroom children",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class _RemoveChildTile extends StatelessWidget {
  final Child child;
  final int classroomId;
  final VoidCallback onRemoved;

  const _RemoveChildTile({
    required this.child,
    required this.classroomId,
    required this.onRemoved,
  });

  Future<void> removeChild() async {
    try {
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.post(
        '/classrooms/$classroomId/remove-children',
        data: {"child_ids": [child.id]},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        print("API Response: ${response.data['message']}");
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Child removed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        onRemoved();
      }
    } catch (e) {
      print("Error removing child: $e");
      Get.snackbar(
        "Error",
        "Failed to remove child",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RemoveChildPage.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: RemoveChildPage.primary.withOpacity(0.2),
            child: Text(
              child.name.isNotEmpty ? child.name[0] : "?",
              style: const TextStyle(
                color: RemoveChildPage.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              child.name,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: removeChild,
            icon: const Icon(Icons.delete),
            color: RemoveChildPage.danger,
            style: IconButton.styleFrom(
              backgroundColor: RemoveChildPage.danger.withOpacity(0.1),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
