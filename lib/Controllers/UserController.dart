import 'package:get/get.dart';
import '../Models/User.dart';

class UserController extends GetxController {
  var user = Rxn<User>();
  var accessToken = ''.obs;



  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  var users = <User>[].obs; // all users loaded somewhere
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++










  String? getUserNameById(int id) {
    final user = users.firstWhereOrNull((u) => u.id == id);
    return user?.name;
  }
}
