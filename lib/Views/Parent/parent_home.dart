import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:frontend/Controllers/ChildrenController.dart';
import 'package:frontend/Models/Child.dart';
import 'package:frontend/Views/Parent/ChildClassrooms.dart';
class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  final ChildrenController controller = Get.put(ChildrenController());

  @override
  void initState() {
    super.initState();
    controller.fetchChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    Text(
                      "Welcome ${controller.user.value?.name ?? ""}  ",
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's how your children are doing:",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: const Color(0xFFA0A0A0),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Children List
                    Obx(() {
                      if (controller.children.isEmpty) {
                        return const Text(
                          "No children found",
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      return Column(
                        children: controller.children.map((child) {
                          return Padding(
                            key: ValueKey(child.id), // unique key per child
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ChildClassrooms(child: child));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2224),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Icon(
                                        child.gender == "female"
                                            ? Icons.face_2
                                            : Icons.male,
                                        color: child.gender == "female"
                                            ? Colors.purple
                                            : Colors.blue,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            child.name,
                                            style: GoogleFonts.manrope(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "DOB: ${child.dateOfBirth}",
                                            style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              color: const Color(0xFFA0A0A0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFFA0A0A0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Navigation

          ],
        ),
      ),
    );
  }

  Widget _navItem({required IconData icon, required String label, bool active = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: active ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0),
          ),
        ),
      ],
    );
  }
}