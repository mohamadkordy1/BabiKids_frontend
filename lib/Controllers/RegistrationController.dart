import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Models/User.dart';
import 'package:frontend/Core/Network/DioClient.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController PhoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password_confirmation = TextEditingController();

  var showPassword = false.obs;
  var showConfirmPassword = false.obs;

  // ------------------- Registration API -------------------
  void registerUser() async {
    // Use the updated User model
    User user = User(
      id: 0, // temporary, API will generate the id
      name: name.text,
      email: email.text,
      PhoneNumber: PhoneNumber.text,
      role: 'parent',
    );

    // Create request body
    final requestBody = {
      "name": user.name,
      "email": user.email,
      "PhoneNumber": user.PhoneNumber,
      "role": user.role,
      "password": password.text,
      "password_confirmation": password_confirmation.text,
    };

    print("Request Body: $requestBody");

    try {
      final response = await DioClient().gettInstance().post(
        '/register',
        data: requestBody,
      );

      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(
            "Registration failed. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _showErrorDialog(_parseErrorMessage(error));
    }
  }


  // ------------------- Success Dialog -------------------
  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1F2937),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Success",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "User registered successfully",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFFD1D5DB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.offNamed('/login'); // go to login page
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Error Dialog -------------------
  void _showErrorDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1F2937),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Error",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFFD1D5DB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "OK",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Parse API Error -------------------
  String _parseErrorMessage(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data != null) {
        // Laravel returns validation errors as a map
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          return errors.values
              .map((v) => (v as List).join('\n'))
              .join('\n');
        }
        return data.toString();
      }
     return error.toString();

    }
    return error.toString();
  }
}
          