import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/Controllers/ClassroomController.dart';
import 'package:frontend/Models/User.dart';

class CreateClassPage extends StatefulWidget {

  const CreateClassPage({super.key, });

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color inputBackground = Color(0xFF374151);
  static const Color placeholderColor = Color(0xFF9CA3AF);

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final ClassroomController classroomController =
  Get.find<ClassroomController>();
  bool isLoading = false;

  void createClass() async {
    final name = classNameController.text.trim();
    final startTime = startTimeController.text.trim();
    final endTime = endTimeController.text.trim();

    if (name.isEmpty || startTime.isEmpty || endTime.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    final success = await classroomController.createClassroom(
      name: name,
      startTime: startTime,
      endTime: endTime,
    );

    setState(() => isLoading = false);

    if (success) {
      Get.snackbar('Success', 'Classroom created successfully');
      Navigator.pop(context); // Return to dashboard
    } else {
      Get.snackbar('Error', 'Failed to create classroom');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreateClassPage.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: CreateClassPage.backgroundDark,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      height: 48,
                      width: 48,
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Create a New Class',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's set up a new class for your students.",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CreateClassPage.placeholderColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Class Name
                    _LabeledInput(
                      controller: classNameController,
                      label: 'Class Name',
                      hint: 'e.g., Monday Morning Math',
                    ),
                    const SizedBox(height: 16),

                    // Start & Finish Time
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledInput(
                            controller: startTimeController,
                            label: 'Class Start Time',
                            hint: '09:00',
                            inputType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledInput(
                            controller: endTimeController,
                            label: 'Class Finish Time',
                            hint: '10:00',
                            inputType: TextInputType.datetime,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Create Class Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : createClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CreateClassPage.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Create Class',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.5,
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
}

/// Custom Input Field
class _LabeledInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType inputType;
  final TextEditingController controller;

  const _LabeledInput({
    required this.label,
    required this.hint,
    required this.controller,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: inputType,
          style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(color: CreateClassPage.placeholderColor),
            filled: true,
            fillColor: CreateClassPage.inputBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
