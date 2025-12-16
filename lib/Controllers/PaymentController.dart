import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../Models/Payment.dart';
import '../Core/Network/DioClient.dart';
import 'UserController.dart';

class PaymentController extends GetxController {
  var payments = <Payment>[].obs;
  var isLoading = false.obs;

  final UserController userController = Get.find<UserController>();

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;

      final response = await DioClient().gettInstance().get(
        '/payments',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken.value}',
          },
        ),
      );

      final dataJson =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (dataJson != null && dataJson['data'] != null) {
        final List list = dataJson['data'];

        // 🔥 FILTER PAYMENTS BY LOGGED-IN PARENT
        final parentId = userController.user.value!.id;

        payments.value = list
            .map((e) => Payment.fromJson(e))
            .where((p) => p.parentId == parentId)
            .toList();
      }
    } catch (e) {
      print("Error fetching payments: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
