import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Views/Login.dart';
import '../Routes/AppRoute.dart';

class LogoutController extends GetxController {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Optional: call API logout here if needed
      // await http.post(...);

      // Remove token
      await prefs.remove('token');
    }

    // Navigate to login and remove all previous routes
    Get.offAllNamed(AppRoute.login);
  }
}
