import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../Controllers/ChildrenController.dart';
import '../../../../Models/Child.dart';
import '../../navbar.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Core/Network/DioClient.dart';
import 'package:frontend/Controllers/UserController.dart';

class AddExistingChildPage extends StatefulWidget {
  final Classroom classroom;
  const AddExistingChildPage({super.key, required this.classroom});

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

  @override
  State<AddExistingChildPage> createState() => _AddExistingChildPageState();
}

class _AddExistingChildPageState extends State<AddExistingChildPage> {
  final ChildrenController childrenController = Get.put(ChildrenController());
  TextEditingController searchController = TextEditingController();
  List<Child> filteredChildren = [];
  Set<int> addedChildIds = {};

  @override
  void initState() {
    super.initState();
    childrenController.fetchChildren1().then((_) {
      filteredChildren = List.from(childrenController.children);
      setState(() {});
    });
  }

  void _filterChildren(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredChildren = childrenController.children
          .where((child) => child.name.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts[1][0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AddExistingChildPage.backgroundDark,
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
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for a child...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: AddExistingChildPage.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AddExistingChildPage.primary),
                  ),
                ),
                onChanged: _filterChildren,
              ),
            ),

            const SizedBox(height: 12),

            // Child List
            Expanded(
              child: Obx(() {
                if (childrenController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (filteredChildren.isEmpty) {
                  return const Center(
                    child: Text("No children found", style: TextStyle(color: Colors.white)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredChildren.length,
                  itemBuilder: (context, index) {
                    final child = filteredChildren[index];
                    final added = addedChildIds.contains(child.id);
                    return _ChildAddTile(
                      childId: child.id,
                      classroomId: widget.classroom.id,
                      initials: _getInitials(child.name),
                      name: child.name,
                      isAdded: added,
                      onAdded: () {
                        setState(() {
                          addedChildIds.add(child.id);
                        });
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
}

class _ChildAddTile extends StatelessWidget {
  final String initials;
  final String name;
  final int childId;
  final int classroomId;
  final bool isAdded;
  final VoidCallback onAdded;

  const _ChildAddTile({
    required this.initials,
    required this.name,
    required this.childId,
    required this.classroomId,
    required this.isAdded,
    required this.onAdded,
  });

  Future<void> addChildToClass() async {
    try {
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.post(
        '/classrooms/$classroomId/add-children',
        data: {
          "child_ids": [childId],
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        onAdded();
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
            icon: Icon(Icons.add, color: isAdded ? Colors.white : Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: isAdded ? Colors.green : AddExistingChildPage.primary,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
