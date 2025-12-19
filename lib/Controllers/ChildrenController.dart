import 'dart:convert';
import 'package:get/get.dart';
import '../Models/Child.dart';
import 'package:dio/dio.dart';
import '../Core/Network/DioClient.dart';
import '../Services/ChildService.dart';
import 'UserController.dart';

class ChildrenController extends GetxController {
  var children = <Child>[].obs;
  var user = Get.find<UserController>().user;

  void fetchChildren() async {
    try {
      children.value = await ChildService.getChildren();
    } catch (e) {
      print("Error loading children: $e");
    }
  }





  Future<void> loadChildren() async {
    try {
      final userController = Get.find<UserController>();
      final dio = DioClient.dio;

      final response =  await dio.get('/children');

      final dataJson = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (dataJson != null && dataJson['data'] != null) {
        final List dataList = dataJson['data'];
        children.value = dataList.map((json) => Child.fromJson(json)).toList();
        print("Loaded ${children.length} children");
      } else {
        print("No data found in response");
      }
    } catch (e) {
      print("Error loading children: $e");
    }
  }
}
