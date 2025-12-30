import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Models/User.dart';
import 'package:get/get.dart'; // For navigation
import 'package:frontend/Views/Admin/payments/payment.dart';
import 'package:frontend/Views/Admin/AddNewChild.dart';
class AdminActionsPage extends StatelessWidget {
  final User user; // Selected user
  const AdminActionsPage({super.key, required this.user});

  // Colors
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDark = Color(0xFF1C2026);
  static const Color surfaceDarkHover = Color(0xFF2A2F36);
  static const Color textSecondary = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // HEADER with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(); // Navigate back
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceDarkHover,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        'ADMIN ACTIONS',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Space for symmetry
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Optional: Show selected user's info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Selected Parent: ${user.name}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
            ),

            // MAIN CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'What would you like to do today?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ADD NEW CHILD BUTTON
                  _actionButton(f:(){Get.to(() => AddNewChildPage(user: user,));},
                    icon: Icons.face,
                    iconBgColor: primary,
                    title: 'Add New Child',
                    subtitle: 'Register a new student',
                    iconColor: Colors.white,
                    hoverBgColor: surfaceDarkHover,
                  ),
                  const SizedBox(height: 20),

                  // SHOW PAYMENTS BUTTON
                  _actionButton(
                    f:(){Get.to(() => ShowPaymentPage(user: user,));},
                    icon: Icons.payments,
                    iconBgColor: surfaceDarkHover,
                    title: 'Show Payments',
                    subtitle: 'View transaction history',
                    iconColor: primary,
                    hoverBgColor: primary,
                    hoverIconColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REUSABLE ACTION BUTTON
  Widget _actionButton({
    required IconData icon,
    required Function f,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Color iconColor,
    Color? hoverBgColor,
    Color? hoverIconColor,
  }) {
    return SizedBox(
      height: 210,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {f();},
        child: Ink(
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: primary.withOpacity(0.2), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ICON
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: hoverIconColor != null
                        ? Border.all(color: primary.withOpacity(0.3), width: 2)
                        : null,
                  ),
                  child: Icon(icon, color: iconColor, size: 32),
                ),
                const SizedBox(height: 16),
                // TITLE & SUBTITLE
                Column(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
