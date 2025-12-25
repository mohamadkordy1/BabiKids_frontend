import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:frontend/Models/Classroom.dart';
class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key, required this.classroom});
final Classroom classroom;
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // placeholder for spacing
                ],
              ),
            ),

            /// ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement delete logic
                      },
                      icon: const Icon(Icons.delete, color: danger),
                      label: const Text("Delete Activity"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: danger.withOpacity(0.2),
                        foregroundColor: danger,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement edit logic
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Edit Activity"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ACTIVITY CARD
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title & Due Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Geometry Quiz",
                            style: GoogleFonts.manrope(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Due: November 25",
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Description
                      Text(
                        "This quiz covers the fundamental concepts of geometry discussed in Chapter 3. Students will be tested on identifying shapes, understanding angles, and basic area calculations. The quiz consists of 10 multiple-choice questions and should take approximately 20 minutes to complete. Make sure to review the chapter materials before starting.",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: Colors.grey[300],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// BOTTOM NAV
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
                color: backgroundDark,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.dashboard, color: primary, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        "Dashboard",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.settings, color: Colors.grey, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        "Settings",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
