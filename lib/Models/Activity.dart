class Activity {
  final int id;
  final String title;
  final String description;
  final int createdBy;
  final int classroomId;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.classroomId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdBy: json['created_by'],
      classroomId: json['classroom_id'],
    );
  }
}
