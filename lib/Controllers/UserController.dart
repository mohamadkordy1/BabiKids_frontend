import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Models/User.dart';

class UserController extends GetxController {
  var user = Rxn<User>();
  var accessToken = ''.obs;

  // EXISTING (DO NOT BREAK)
  var parents = <User>[].obs;
  var isLoadingParents = false.obs;

  // ✅ NEW (SAFE ADDITION)
  var allUsers = <User>[].obs;
  var isLoadingUsers = false.obs;

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

  /// EXISTING METHOD (UNCHANGED)
  Future<void> fetchParents() async {
    try {
      isLoadingParents.value = true;

      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://babikids.test/api/v1',
          headers: {
            'Authorization': 'Bearer ${accessToken.value}',
          },
        ),
      );

      final response = await dio.get('/users');

      final users = (response.data['data'] as List)
          .map((u) => User.fromJson(u))
          .toList();

      parents.value =
          users.where((u) => u.role.toLowerCase() == 'parent').toList();
    } catch (e) {
      print('Failed to fetch parents: $e');
    } finally {
      isLoadingParents.value = false;
    }
  }

  // ✅ NEW METHOD — FETCH ALL USERS
  Future<void> fetchAllUsers() async {
    try {
      isLoadingUsers.value = true;

      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://babikids.test/api/v1',
          headers: {
            'Authorization': 'Bearer ${accessToken.value}',
          },
        ),
      );

      final response = await dio.get('/users');

      allUsers.value = (response.data['data'] as List)
          .map((u) => User.fromJson(u))
          .toList();
    } catch (e) {
      print('Failed to fetch users: $e');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> updateUserRoleOnly({
    required User user,
    required String newRole,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://babikids.test/api/v1',
          headers: {
            'Authorization': 'Bearer ${accessToken.value}',
          },
        ),
      );
      final response = await dio.put(
        '/users/${user.id}',
        data: {
          'name': user.name,                // SAME
          'email': user.email,              // SAME
          'PhoneNumber': user.PhoneNumber,  // SAME
          'role': newRole,                  // ONLY CHANGE
        },
      );

      // Update local user list
      allUsers.value = allUsers.map((u) {
        if (u.id == user.id) {
          return User.fromJson(response.data['data']);
        }
        return u;
      }).toList();

      Get.snackbar('Success', 'Role updated successfully');
    } catch (e) {
      print('Role update failed: $e');
      Get.snackbar('Error', 'Failed to update role');
    }
  }

}
