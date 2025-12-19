class Classroom {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final String teacher;
  final List<String> children;

  Classroom({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.children,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json['id'],
    name: json['name'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    teacher: json['teacher'] ?? '',
    children: json['children'] != null
        ? List<String>.from(json['children'])
        : [],
  );
}
