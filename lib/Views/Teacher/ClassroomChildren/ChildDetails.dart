import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/Child.dart';
import 'package:get/get.dart';
import 'package:frontend/Models/Classroom.dart';
import 'CreateAReport.dart';

class ChildDetailsPage extends StatelessWidget {
  final Child child;
  final Classroom classroom;

  const ChildDetailsPage({super.key, required this.child,required this.classroom});

  static const Color primary = Color(0xFF3B82F6);
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
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      "${child.name}'s Details",
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

            /// CONTENT
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    _infoCard("Name", child.name),
                    const SizedBox(height: 16),
                    _infoCard("Date of Birth", child.dateOfBirth),
                    const SizedBox(height: 16),
                    _infoCard("Gender", child.gender),
                  ],
                ),
              ),
            ),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {        Get.to(() => CreateReportPage(child:child ,));
                  },
                  icon: const Icon(Icons.description, color: Colors.white),
                  label: Text(
                    "Make a Report",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
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

  /// INFO CARD
  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
