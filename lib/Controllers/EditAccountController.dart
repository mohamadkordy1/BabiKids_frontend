import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import 'UserController.dart';

class EditAccountController extends GetxController {
  final userController = Get.find<UserController>();

  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    final user = userController.user.value!;
    name.value = user.name;
    email.value = user.email;
    phone.value = user.PhoneNumber ?? '';
    super.onInit();
  }

  Future<void> updateProfile() async {
    if (password.value.isEmpty || confirmPassword.value.isEmpty) {
      Get.snackbar("Error", "Password is required");
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "name": name.value,
        "email": email.value,
        "PhoneNumber": phone.value,
        "password": password.value,
        "password_confirmation": confirmPassword.value,
        "role": userController.user.value!.role, // unchanged
      };

      /// 🔍 DEBUG (VERY IMPORTANT)
      print("SENDING BODY => $body");
      final dio = DioClient.dio;

      final response = await dio.get('/users/${userController.user.value!.id}');

      userController.user.value = userController.user.value!.copyWith(
        name: name.value,
        email: email.value,
        phoneNumber: phone.value,
      );

      Get.back();
      Get.snackbar("Success", "Account updated successfully");
    } catch (e) {
      print("UPDATE ERROR => $e");
      Get.snackbar("Error", "Failed to update account");
    } finally {
      isLoading.value = false;
    }
  }
}
