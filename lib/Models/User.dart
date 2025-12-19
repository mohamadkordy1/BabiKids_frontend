import 'dart:convert';

class User {
   int id;
   String name;
   String email;
   String PhoneNumber;
   String role;
   String? createdAt;
   String? updatedAt;
   String? deletedAt;

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
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      PhoneNumber: phoneNumber ?? this.PhoneNumber,
      role: role ?? this.role,
    );
  }


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
