import 'package:dio/dio.dart';
import '../Models/User.dart';

class UserService {
  static Future<User> getUser(int id) async {
    final response =
    await Dio().get("http://babikids.test/api/v1/users/$id");

    // Backend returns { "data": { ... } }
    return User.fromJson(response.data["data"]);
  }

static Future<List<User>> getAllUsers() async {
final response =
    await Dio().get("http://babikids.test/api/v1/users");

// Backend returns { data: [ ... ] }
return (response.data['data'] as List)
    .map((u) => User.fromJson(u))
    .toList();
}
}