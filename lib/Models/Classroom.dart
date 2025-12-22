class Classroom {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final int teacherId;
  final String teacher;
  final List<dynamic> children;

  Classroom({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
    required this.teacher,
    required this.children,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      teacherId: json['teacher_id'] ?? 0, // SAFE
      teacher: json['teacher'] ?? '',
      children: json['children'] ?? [],
    );
  }
}
