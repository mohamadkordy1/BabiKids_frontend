import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Core/Network/DioClient.dart';
import '../Models/User.dart';
import 'UserController.dart';
import 'ChildrenController.dart';
import '../Routes/AppRoute.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var showPassword = false.obs;

  /// Login user and navigate based on role
  void loginUser() async {
    final requestBody = {
      'email': email.text.trim(),
      'password': password.text,
    };

    try {
      final response = await DioClient.dio.post(
        '/login',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Initialize controllers
        final userController = Get.put(UserController(), permanent: true);
        final childrenController = Get.put(ChildrenController(), permanent: true);

        // Set user and token
        userController.setUser(
          User.fromJson(data['user']),
          data['access_token'],
        );

        // Set token globally for all future requests
        DioClient.setToken(data['access_token']);

        // Load children if parent
        if (data['user']['role'] == 'parent') {
          await childrenController.fetchChildren();
        }

        // Navigate based on role
        final role = data['user']['role'];
        if (role == 'teacher') {
          Get.offAllNamed(AppRoute.teacherDashboard);
        } else {
          Get.offAllNamed(AppRoute.parentShell); // default = parent
        }
      } else {
        Get.snackbar('Error', 'Login failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login error: $e');
    }
  }
}
