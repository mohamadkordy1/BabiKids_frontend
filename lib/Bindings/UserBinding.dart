import 'package:get/get.dart';
import '../Controllers/UserController.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());        // Create globally (recommended)
    // or:
    // Get.lazyPut<UserController>(() => UserController());
  }
}
