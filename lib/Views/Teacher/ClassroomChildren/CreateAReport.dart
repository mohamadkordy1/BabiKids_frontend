import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Models/Child.dart';
import '../../../Controllers/UserController.dart';
import '../../../Core/Network/DioClient.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class CreateReportPage extends StatelessWidget {
  final Child child;
  const CreateReportPage({super.key, required this.child});

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color inputBackground = Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: backgroundDark,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Create New Report",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // FORM
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // REPORT CONTENT
                      _buildLabelInput(
                        label: "Report Content",
                        hint: "Describe the details of your report here...",
                        controller: contentController,
                        maxLines: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final content = contentController.text.trim();
                    if (content.isEmpty) {
                      Get.snackbar("Error", "Please enter report content",
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    try {
                      // Set token
                      DioClient.setToken(userController.accessToken.value);

                      // Use current date
                      final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

                      // POST request
                      final response = await DioClient.dio.post(
                        '/reports',
                        data: {
                          "child_id": child.id.toString(),
                          "report_date": currentDate,
                          "report_type": "text",
                          "content": content,
                          "created_by": userController.user.value?.id.toString(),
                        },
                      );

                      if (response.statusCode == 200 || response.statusCode == 201) {
                        Get.snackbar(
                          "Success",
                          "Report created successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Navigator.pop(context);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Failed to create report",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      print("Error creating report: $e");
                      Get.snackbar(
                        "Error",
                        "An error occurred while creating report",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text(
                    "Submit Report",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildLabelInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: inputBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
