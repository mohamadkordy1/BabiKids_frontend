class Child {
  final int id;
  final String name;
  final String gender;
  final String dateOfBirth;
  final int parentId;

  Child({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.parentId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      parentId: json['parent_id'],
    );
  }
}
