import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
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
      final response = await DioClient().gettInstance().post(
        '/login',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save user and token in permanent controllers
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

        userController.accessToken.value = data['access_token'];

        // Load children
        await childrenController.loadChildren();

        // Navigate to home
        Get.offAllNamed(AppRoute.parentShell);
      } else {
        Get.snackbar('Error', 'Login failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login error: $e');
    }
  }
}
