import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String PhoneNumber;
  final String role;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.PhoneNumber,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // ------------------- Convert JSON Map to User -------------------
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      PhoneNumber: json['PhoneNumber'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  // ------------------- Convert User to JSON Map -------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'PhoneNumber': PhoneNumber,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  // ------------------- Convert User to JSON string -------------------
  String toJson() => jsonEncode(toMap());

  // ------------------- Optional: Display for debugging -------------------
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, PhoneNumber: $PhoneNumber, role: $role)';
  }
}
