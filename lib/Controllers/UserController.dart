import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/User.dart';


class UserController extends GetxController {
  var user = Rxn<User>();
  var accessToken = ''.obs;

  // Save the user's password locally
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (accessToken.value.isNotEmpty) {
      fetchUser();
    }
  }


  Future<void> fetchUser() async {
    try {
      final response = await DioClient.dio.get(
        '/users/${user.value!.id}', // replace 2 with current user ID if needed
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      final dataJson = response.data['data'];
      user.value = User.fromJson(dataJson);

      // Save password locally (for sending back later)
      password.value = 'current_password_here'; // Set the actual password when logging in
    } catch (e) {
      print('Failed to load user info: $e');
    }
  }

  Future<void> updateUser({required String name, required String email, required String phoneNumber}) async {
    if (user.value == null) return;

    try {
      final response = await DioClient.dio.put(
        '/users/${user.value!.id}',
        data: {
          'name': name,
          'email': email,
          'PhoneNumber': phoneNumber,
          'password': password.value,
          'password_confirmation': password.value,
          'role': user.value!.role,

        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      final dataJson = response.data['data'];
      user.value = User.fromJson(dataJson);
      Get.snackbar('Success', 'User info updated successfully');
    }catch (e) {
      if (e is DioException) {
        print("STATUS CODE: ${e.response?.statusCode}");
        print("RESPONSE DATA: ${e.response?.data}");
      } else {
        print(e);
      }
    }
  }}
