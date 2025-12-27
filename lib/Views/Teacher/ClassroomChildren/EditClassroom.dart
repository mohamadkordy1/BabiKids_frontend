import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Controllers/ClassroomController.dart';

class EditClassRoomPage extends StatefulWidget {
  const EditClassRoomPage({
    super.key,
    required this.classroom,
  });

  final Classroom classroom;

  @override
  State<EditClassRoomPage> createState() => _EditClassRoomPageState();
}

class _EditClassRoomPageState extends State<EditClassRoomPage> {
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color inputDark = Color(0xFF374151);

  final ClassroomController classroomController =
  Get.find<ClassroomController>();

  late TextEditingController classNameController;
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    classNameController =
        TextEditingController(text: widget.classroom.name);

    startTime = _parseTime(widget.classroom.startTime);
    endTime = _parseTime(widget.classroom.endTime);
  }

  @override
  void dispose() {
    classNameController.dispose();
    super.dispose();
  }

  // ------------------- Helpers -------------------

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _pickTime({
    required TimeOfDay initial,
    required Function(TimeOfDay) onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  Future<void> _updateClassroom() async {
    if (classNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Class name cannot be empty");
      return;
    }

    if (endTime.hour < startTime.hour ||
        (endTime.hour == startTime.hour &&
            endTime.minute <= startTime.minute)) {
      Get.snackbar("Error", "End time must be after start time");
      return;
    }

    setState(() => isLoading = true);

    final success = await classroomController.updateClassroom(
      classroomId: widget.classroom.id,
      name: classNameController.text.trim(),
      startTime: _formatTime(startTime),
      endTime: _formatTime(endTime),
    );

    setState(() => isLoading = false);

    if (success) {
      Get.back();
      Get.snackbar(
        "Success",
        "Classroom updated successfully",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to update classroom",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  // ------------------- UI -------------------

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "Edit Classroom",
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

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update your classroom information below.",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// CLASS NAME
                    _label("Class Name"),
                    TextField(
                      controller: classNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hint: "e.g. Class A",
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TIME ROW
                    Row(
                      children: [
                        Expanded(
                          child: _timePicker(
                            label: "Start Time",
                            time: startTime,
                            onTap: () => _pickTime(
                              initial: startTime,
                              onSelected: (t) =>
                                  setState(() => startTime = t),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _timePicker(
                            label: "End Time",
                            time: endTime,
                            onTap: () => _pickTime(
                              initial: endTime,
                              onSelected: (t) =>
                                  setState(() => endTime = t),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// UPDATE BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateClassroom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Classroom"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- Widgets -------------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _timePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: inputDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time.format(context),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: inputDark,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
