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

  void loginUser() async {
    final requestBody = {
      'email': email.text,
      'password': password.text,
    };

    try {
      final response = await DioClient.dio.post(
        '/login',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save user
        final userController =
        Get.put(UserController(), permanent: true);
        final childrenController =
        Get.put(ChildrenController(), permanent: true);

        userController.user.value = User(
          id: data['user']['id'],
          name: data['user']['name'],
          email: data['user']['email'],
          PhoneNumber: data['user']['PhoneNumber'],
          role: data['user']['role'],
        );

        // ✅ SET TOKEN ONCE (CRITICAL)
        userController.accessToken.value = data['access_token'];
        DioClient.setToken(data['access_token']);

        // Load protected data
        await childrenController.loadChildren();

        Get.offAllNamed(AppRoute.parentShell);
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login error: $e');
    }
  }
}
