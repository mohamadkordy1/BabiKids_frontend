import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Controllers/ActivityController.dart';
class CreateActivityPage extends StatelessWidget {
  final Classroom classroom;

  CreateActivityPage({super.key, required this.classroom});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color inputDark = Color(0xFF374151);

  @override
  Widget build(BuildContext context) {
    final activityController = Get.put(ActivityController());

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "Create Activity",
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

            /// FORM
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Activity Title"),
                    _input(titleController, "e.g. Geometry Quiz"),

                    const SizedBox(height: 20),

                    _label("Activity Description"),
                    _input(
                      descriptionController,
                      "Add a short description...",
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),

            /// SAVE BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: activityController.isLoading.value
                        ? null
                        : () {
                      activityController.createActivity(
                        title: titleController.text,
                        description: descriptionController.text,
                        classroomId: classroom.id, // 🔥 KEY POINT
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: activityController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Create Activity",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey[300],
    ),
  );

  Widget _input(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: inputDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
