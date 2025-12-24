import 'package:get/get.dart';
import '../Models/Child.dart';
import '../Core/Network/DioClient.dart';
import 'UserController.dart';

class ChildrenController extends GetxController {
  var children = <Child>[].obs;
  var isLoading = false.obs;
  var user = Get.find<UserController>().user;
  final userController = Get.find<UserController>();

  Future<void> fetchChildren() async {
    try {
      isLoading.value = true;

      final response = await DioClient.dio.get('/children');
      final List data = response.data['data'];

      final allChildren =
      data.map((e) => Child.fromJson(e)).toList();

      final parentId = userController.user.value!.id;

      // ✅ FRONTEND FILTERING HERE
      children.value = allChildren
          .where((child) => child.parentId == parentId)
          .toList();

      print("Filtered ${children.length} children");
    } catch (e) {
      print("Error loading children: $e");
    } finally {
      isLoading.value = false;
    }
  }

Future<void> fetchChildren1() async {
  try {
    isLoading.value = true;

    final response = await DioClient.dio.get('/children');
    final List data = response.data['data'];

    final allChildren = data.map((e) => Child.fromJson(e)).toList();

    // ✅ Safe change: show all children
    // final parentId = userController.user.value!.id;
    // children.value = allChildren.where((child) => child.parentId == parentId).toList();

    children.value = allChildren; // display all children

    print("Loaded ${children.length} children");
  } catch (e) {
    print("Error loading children: $e");
  } finally {
    isLoading.value = false;
  }
}
}