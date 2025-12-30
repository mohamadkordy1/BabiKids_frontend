import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/UserController.dart';
import '../../../Controllers/LogoutController.dart';
import '../../../Views/parentNav/Settings/setting2.dart';
import '../../../Views/parentNav/Settings/setting3.dart';
import 'AppBottomNav.dart';


class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final userController = Get.find<UserController>();
  final LogoutController logoutController = Get.put(LogoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111418),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    "Account Settings",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- CONTENT ----------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final user = userController.user.value;

                  if (user == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Name"),
                      _displayField(user.name),
                      const SizedBox(height: 20),

                      _label("Email"),
                      _displayField(user.email),
                      const SizedBox(height: 20),

                      _label("Phone Number"),
                      _displayField(user.PhoneNumber ?? "—"),
                      const SizedBox(height: 20),

                      _label("Password"),
                      _displayField("********"),
                      const SizedBox(height: 32),

                      // -------- EDIT BUTTON --------
                      _primaryButton(
                        text: "Edit Account Information",
                        onPressed: () {
                          Get.to(() => const EditAccountPage());
                        },
                      ),
                      const SizedBox(height: 12),

                      // -------- CHANGE PASSWORD --------
                      _secondaryButton(
                        text: "Change Password",
                        onPressed: () {
                          Get.to(() => const ChangePasswordPage());

                        },
                      ),
                      const SizedBox(height: 32),

                      // -------- LOGOUT --------
                      _logoutButton(
                        onPressed: () async {
                          await logoutController.logout();
                        },
                      ),

                    ],
                  );
                }),
              ),
            ),   const AppBottomNav(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _displayField(String value) {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1F2937),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3B82F6),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton({required VoidCallback onPressed}) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          "Log Out",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
