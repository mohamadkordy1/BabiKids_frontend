import 'package:get/get.dart';
import '../Models/User.dart';

class UserController extends GetxController {
  var user = Rxn<User>();
  var accessToken = ''.obs;
}
