import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/User.dart';



class UserController extends GetxController {
  var user = Rxn<User>();
  var accessToken = ''.obs;

  /// Called AFTER LOGIN
  void setUser(User newUser, String token) {
    user.value = newUser;
    accessToken.value = token;
  }

  /// Update profile (NO password)
  Future<void> updateUser({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    if (user.value == null) return;

    try {
      final response = await Get.find<Dio>().put(
        '/users/${user.value!.id}',
        data: {
          'name': name,
          'email': email,
          'PhoneNumber': phoneNumber,
          'role': user.value!.role,
        },
      );

      user.value = User.fromJson(response.data['data']);
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      print('Update failed: $e');
    }
  }
}
