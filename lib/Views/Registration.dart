import 'package:flutter/material.dart';
import 'package:frontend/Controllers/RegistrationController.dart';
import 'package:frontend/Routes/AppRoute.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends GetView<RegistrationController> {
  Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "Create Your Account",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Let the learning adventure begin!",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Color(0xFFD1D5DB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _label("Name"),
            _inputField(controller: controller.name, hint: "Enter your name"),
            const SizedBox(height: 20),
            _label("Email"),
            _inputField(controller: controller.email, hint: "Enter your email address"),
            const SizedBox(height: 20),
            _label("Phone Number"),
            _inputField(controller: controller.PhoneNumber, hint: "Enter your phone number"),
            const SizedBox(height: 20),
            _label("Password"),
            Obx(() => _passwordField(
                  controller: controller.password,
                  hint: "Create a password",
                  visible: controller.showPassword.value,
                  onToggle: () {
                    controller.showPassword.value = !controller.showPassword.value;
                  },
                )),
            const SizedBox(height: 20),
            _label("Confirm Password"),
            Obx(() => _passwordField(
                  controller: controller.password_confirmation,
                  hint: "Confirm your password",
                  visible: controller.showConfirmPassword.value,
                  onToggle: () {
                    controller.showConfirmPassword.value = !controller.showConfirmPassword.value;
                  },
                )),
            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  controller.registerUser();
                },
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "By signing up, you agree to our Terms of Service and Privacy Policy.",
              style: GoogleFonts.inter(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoute.login);
              },
              child: Text(
                "Login",
                style: GoogleFonts.manrope(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Color(0xFFD1D5DB),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _inputField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFD1D5DB),
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF374151),
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Color(0xFF9CA3AF)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF3B82F6),
          width: 2,
        ),
      ),
    );
  }
}
