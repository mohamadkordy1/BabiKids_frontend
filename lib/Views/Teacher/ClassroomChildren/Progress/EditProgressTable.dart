import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../../../../Controllers/UserController.dart';
import '../../../../Core/Network/DioClient.dart';
import '../../../../Models/Progress.dart' as model;

class EditProgressPage extends StatefulWidget {
  final model.Progress progress;

  const EditProgressPage({super.key, required this.progress});

  @override
  State<EditProgressPage> createState() => _EditProgressPageState();
}

class _EditProgressPageState extends State<EditProgressPage> {
  late TextEditingController titleController;
  late TextEditingController notesController;
  String status = '';
  DateTime? targetDate;

  final List<String> statusOptions = ['in-progress', 'completed'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.progress.goalTitle);
    notesController = TextEditingController(text: widget.progress.notes);
    status = statusOptions.contains(widget.progress.status)
        ? widget.progress.status
        : statusOptions[0];
    targetDate = _parseDate(widget.progress.targetDate);
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('-');
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }
  Future<void> saveChanges() async {
    final token = Get.find<UserController>().accessToken.value;

    // Construct the body
    final body = {
      "classroom_id": widget.progress.classroomId,
      "goal_title": titleController.text,
      "start_date": widget.progress.startDate,
      "target_date": targetDate != null
          ? "${targetDate!.year.toString().padLeft(4,'0')}-${targetDate!.month.toString().padLeft(2,'0')}-${targetDate!.day.toString().padLeft(2,'0')}"
          : widget.progress.targetDate,
      "status": status,
      "notes": notesController.text,
    };

    // Print the body to console
    print("Request Body: $body");

    try {
      final response = await DioClient.dio.put(
        'http://babikids.test/api/v1/progresses/${widget.progress.id}',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        data: body, // send the same body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Progress updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back(result: true);
      } else {
        Get.snackbar(
          "Error",
          "Failed to update progress",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update progress: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }


  Future<void> deleteProgress() async {
    try {
      final token = Get.find<UserController>().accessToken.value;

      final response = await DioClient.dio.delete(
        'http://babikids.test/api/v1/progresses/${widget.progress.id}',
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Deleted",
          response.data['message'] ?? "Progress deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back(result: true);
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete progress",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete progress: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: targetDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF3B82F6),
            onPrimary: Colors.white,
            surface: const Color(0xFF1A1C1E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        targetDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0E10),
        title: Text("Edit Progress", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Progress Title", style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "e.g. Algebra Module 1",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: const Color(0xFF1A1C1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status", style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFF1A1C1E), borderRadius: BorderRadius.circular(16)),
                        child: DropdownButton<String>(
                          value: status,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1A1C1E),
                          underline: const SizedBox(),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          items: statusOptions
                              .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s[0].toUpperCase() + s.substring(1)),
                          ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => status = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target Date", style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: pickTargetDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(color: const Color(0xFF1A1C1E), borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            targetDate != null ? DateFormat('dd-MM-yyyy').format(targetDate!) : "Select Date",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Notes", style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: notesController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add notes...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: const Color(0xFF1A1C1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: saveChanges,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: deleteProgress,
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: const Text("Delete Progress", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            ),
          ],
        ),
      ),
    );
  }
}
