import 'package:dio/dio.dart';
import '../Models/User.dart';

class UserService {
  static Future<User> getUser(int id) async {
    final response =
    await Dio().get("http://babikids.test/api/v1/users/$id");

    // Backend returns { "data": { ... } }
    return User.fromJson(response.data["data"]);
  }
}
