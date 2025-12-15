import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Models/Report.dart';

class ReportDetailsPage extends StatelessWidget {
  final Report report;
  final String childName;
  final String authorName;

  const ReportDetailsPage({
    super.key,
    required this.report,
    required this.childName,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Report Details",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // REPORT BODY
                    // Replace the current Expanded -> Padding -> Container block
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Container(
                          width: double.infinity, // Make it full screen width
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C1E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            report.content ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.6,
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(height: 16),

                    // REPORT AUTHOR
                    Container(
                      width: double.infinity, // full screen width
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1C1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report Made By:",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authorName ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
