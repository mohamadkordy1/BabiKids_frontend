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
  Future<void> loginUser() async {
    final requestBody = {
      'email': email.text.trim(),
      'password': password.text,
    };

    try {
      final response = await DioClient.dio.post('/login', data: requestBody);

      if (response.statusCode == 200) {
        final data = response.data;

        final userController = Get.put(UserController(), permanent: true);
        final childrenController = Get.put(ChildrenController(), permanent: true);

        userController.setUser(User.fromJson(data['user']), data['access_token']);
        DioClient.setToken(data['access_token']);

        if (data['user']['role'] == 'parent') {
          await childrenController.fetchChildren();
        }

        final role = data['user']['role'];
        if (role == 'teacher') {
          Get.offAllNamed(AppRoute.teacherDashboard);
        } else {
          Get.offAllNamed(AppRoute.parentShell);
        }
      } else {
        Get.snackbar('Login Failed', 'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
    }
  }

}
