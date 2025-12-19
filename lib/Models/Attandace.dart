class Attendance {
  final int id;
  final String date; // "13-08-2025"
  final String status;
  final String checkInTime;
  final String checkOutTime;
  final int childId;
  final int classroomId;

  Attendance({
    required this.id,
    required this.date,
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
    required this.childId,
    required this.classroomId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: json['date'],
      status: json['status'],
      checkInTime: json['check_in_time'] ?? '',
      checkOutTime: json['check_out_time'] ?? '',
      childId: json['child_id'],
      classroomId: json['classroom_id'],
    );
  }

  int get day {
    try {
      final parts = date.split('-'); // ["13", "08", "2025"]
      return int.parse(parts[0]);
    } catch (e) {
      return 0;
    }
  }

  int get month {
    try {
      final parts = date.split('-'); // ["13", "08", "2025"]
      return int.parse(parts[1]);
    } catch (e) {
      return 0;
    }
  }

int get year {
  try {
    final parts = date.split('-'); // ["13", "08", "2025"]
    return int.parse(parts[2]);
  } catch (e) {
    return 0;
  }
}
}