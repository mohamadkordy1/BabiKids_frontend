import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ReportDetailsPage extends StatelessWidget {
  const ReportDetailsPage({super.key});

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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Q3 Performance Report",
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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1C1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SingleChildScrollView(
                          child: DefaultTextStyle(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.6,
                              color: const Color(0xFFE0E0E0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "This report provides a comprehensive summary of Emily's performance and progress during the third quarter. We have observed significant improvements across all core subjects, particularly in Mathematics and Reading Comprehension.",
                                ),
                                SizedBox(height: 16),

                                Text(
                                  "Key Highlights:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),

                                Bullet(text: "Achieved a 90% accuracy rate in Math problem-solving exercises, up from 78% in Q2."),
                                Bullet(text: "Completed the \"Advanced Vocabulary\" module in Reading, demonstrating a strong grasp of new words and their contexts."),
                                Bullet(text: "Showed increased engagement in Science lessons, actively participating in virtual experiments and discussions."),
                                Bullet(text: "Attendance remains excellent at 95%, indicating a consistent and positive learning routine."),

                                SizedBox(height: 16),

                                Text(
                                  "Areas for Focus:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),

                                Text(
                                  "While progress has been strong, we recommend focusing on creative writing skills. Encouraging daily journaling or storytelling can help enhance sentence structure and narrative development.",
                                ),
                                SizedBox(height: 12),

                                Text(
                                  "Overall, Emily is on a fantastic trajectory. Her curiosity and dedication are commendable. We are excited to see her continued growth in the upcoming quarter.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // REPORT AUTHOR
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1C1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report Generated By:",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ms. Eleanor Vance",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Lead Educator",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF3B82F6),
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

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1C1E),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            BottomNav(icon: Icons.dashboard, label: "Dashboard", active: false),
            BottomNav(icon: Icons.payments, label: "Payments", active: false),
            BottomNav(icon: Icons.description, label: "Reports", active: true),
            BottomNav(icon: Icons.settings, label: "Settings", active: false),
          ],
        ),
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  final String text;
  const Bullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(color: Colors.white)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNav({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF3B82F6) : const Color(0xFFE0E0E0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
