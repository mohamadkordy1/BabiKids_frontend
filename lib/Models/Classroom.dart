class Classroom {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  Classroom({required this.id, required this.name, required this.startTime, required this.endTime});

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json['id'],
    name: json['name'],
    startTime: json['start_time'],
    endTime: json['end_time'],
  );
}
