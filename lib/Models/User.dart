import 'dart:convert';

class User {
  final String name;
  final String email;
  final String PhoneNumber;
  final String password;
  final String password_confirmation;
  final String role;
  User({required this.email,required this.name, required this.PhoneNumber , required this.password,  required this.password_confirmation, required this.role});


Map <String, dynamic> ToMap() {
  return {
    "email": email,
    "name": name,
    "PhoneNumber": PhoneNumber,
    "password": password,
    "password_confirmation": password_confirmation,
    "role":"parent",
  };


}
String tojson()=>jsonEncode(ToMap());
}


