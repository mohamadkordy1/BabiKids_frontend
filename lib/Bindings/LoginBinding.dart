import 'package:frontend/Controllers/LoginController.dart';
import 'package:get/get.dart';
class Loginbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }

}