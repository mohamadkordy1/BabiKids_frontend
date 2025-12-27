import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../Models/Classroom.dart';
import '../../../../Controllers/UserController.dart';
import '../../../../Core/Network/DioClient.dart';

class CreateProgressPage extends StatefulWidget {
  final Classroom classroom;
  const CreateProgressPage({super.key, required this.classroom});

  @override
  State<CreateProgressPage> createState() => _CreateProgressPageState();
}

class _CreateProgressPageState extends State<CreateProgressPage> {
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF0C0E10);
  static const Color inputBackground = Color(0xFF1A1C1E);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? targetDate;

  final userController = Get.find<UserController>();
  final String status = "in-progress"; // Fixed initial status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Create New Progress",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Progress Title
                      _buildLabelInput(
                        label: "Progress Title",
                        hint: "e.g. Algebra Module 1",
                        controller: titleController,
                      ),
                      const SizedBox(height: 20),

                      // Target Date
                      _buildTargetDatePicker(),
                      const SizedBox(height: 20),

                      // Notes
                      _buildLabelInput(
                        label: "Notes",
                        hint: "Add specific goals, observations, or requirements for this progress entry...",
                        controller: notesController,
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SAVE BUTTON
            Padding(
              padding: const EdgeInsets.all(20),
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
                  onPressed: _saveProgress,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Save Progress",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ],
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
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 6),
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
              borderSide: BorderSide(color: primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target Date",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: targetDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: primary,
                      onPrimary: Colors.white,
                      surface: backgroundDark,
                      onSurface: Colors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(foregroundColor: primary),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                targetDate = picked;
              });
            }
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: inputBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Text(
              targetDate != null
                  ? DateFormat('dd-MM-yyyy').format(targetDate!)
                  : "Select Date",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProgress() async {
    final String goalTitle = titleController.text.trim();
    final String notes = notesController.text.trim();

    if (goalTitle.isEmpty || targetDate == null) {
      Get.snackbar(
        "Error",
        "Please enter title and select target date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Set token in Dio headers
      DioClient.setToken(userController.accessToken.value);

      final String startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final String targetDateStr = DateFormat('dd-MM-yyyy').format(targetDate!);

      final response = await DioClient.dio.post(
        '/progresses',
        data: {
          "classroom_id": widget.classroom.id.toString(),
          "goal_title": goalTitle,
          "start_date": startDate,
          "target_date": targetDateStr,
          "status": status, // Always in-progress
          "notes": notes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Progress record created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Get.snackbar(
          "Error",
          "Failed to create progress",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error creating progress: $e");
      Get.snackbar(
        "Error",
        "An error occurred while creating progress",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
