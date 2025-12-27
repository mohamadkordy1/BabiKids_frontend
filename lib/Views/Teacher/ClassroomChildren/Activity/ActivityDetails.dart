import 'package:flutter/material.dart';
import 'package:frontend/Models/User.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/Models/Activity.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:dio/dio.dart';
import '../../../../Core/Network/DioClient.dart';

class ActivityDetailsPage extends StatelessWidget {
  final Activity activity; // receive the selected activity

  const ActivityDetailsPage({super.key, required this.activity});

  static const Color primary = Color(0xFF3B82F6);
  static const Color danger = Color(0xFFEF4444);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

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
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Activity Details",
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

            /// DELETE BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Are you sure you want to delete this activity?"),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  try {
                    final token = Get.find<UserController>().accessToken.value;
                    final response = await DioClient.dio.delete(
                      'http://babikids.test/api/v1/activities/${activity.id}',
                      options: Options(headers: {"Authorization": "Bearer $token"}),
                    );

                    if (response.statusCode == 200) {
                      Get.back(result: true); // go back and notify previous page
                      Get.snackbar(
                        "Deleted",
                        "Activity deleted successfully",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to delete activity",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to delete activity: $e",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },


                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Delete Activity"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),


            /// ACTIVITY CARD
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity, // makes card full width
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          activity.title,
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Description
                        Text(
                          activity.description,
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            color: Colors.grey[300],
                            height: 1.6,
                          ),
                        ),
                      ],
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
