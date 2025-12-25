import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Controllers/ChildrenController.dart';
import '../../../Models/Child.dart';
import '../navbar.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Core/Network/DioClient.dart';
import 'package:frontend/Controllers/UserController.dart';

class AddExistingChildPage extends StatelessWidget {
  final Classroom classroom;
  AddExistingChildPage({super.key, required this.classroom});

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

  final ChildrenController childrenController = Get.put(ChildrenController());

  @override
  Widget build(BuildContext context) {
    // Fetch all children when the page loads
    childrenController.fetchChildren1();

    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
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
                      "Add Existing Child",
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

            // Search Field
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

            const SizedBox(height: 12),

            // Child List
            Expanded(
              child: Obx(() {
                if (childrenController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (childrenController.children.isEmpty) {
                  return const Center(
                    child: Text("No children found", style: TextStyle(color: Colors.white)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: childrenController.children.length,
                  itemBuilder: (context, index) {
                    final child = childrenController.children[index];
                    return _ChildAddTile(
                      childId: child.id,
                      classroomId: classroom.id,
                      initials: _getInitials(child.name),
                      name: child.name,
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

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts[1][0];
  }
}

class _ChildAddTile extends StatelessWidget {
  final String initials;
  final String name;
  final int childId;
  final int classroomId;

  const _ChildAddTile({
    required this.initials,
    required this.name,
    required this.childId,
    required this.classroomId,
  });

  // Function to add child to classroom
  Future<void> addChildToClass() async {
    try {
      final token = Get.find<UserController>().accessToken.value;


      final response = await DioClient.dio.post(
        '/classrooms/$classroomId/add-children',
        data: {
          "child_ids": [childId], // ✅ Correct API format
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("API Response: ${response.data['message']} (Child: $name)");
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Child added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error adding child $name: $e");
      Get.snackbar(
        "Error",
        "Failed to add child",
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
        color: AddExistingChildPage.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AddExistingChildPage.primary.withOpacity(0.2),
            child: Text(
              initials,
              style: const TextStyle(
                color: AddExistingChildPage.primary,
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: addChildToClass,
            icon: const Icon(Icons.add),
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: AddExistingChildPage.primary,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

String _getInitials(String name) {
  final parts = name.split(' ');
  if (parts.isEmpty) return "";
  if (parts.length == 1) return parts[0][0];
  return parts[0][0] + parts[1][0];
}
