class Progress {
  final int id;
  final int classroomId;
  final String goalTitle;
  final String startDate;
  final String targetDate;
  final String status;
  final String notes;

  Progress({
    required this.id,
    required this.classroomId,
    required this.goalTitle,
    required this.startDate,
    required this.targetDate,
    required this.status,
    required this.notes,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] ?? 0,
      classroomId: json['classroom_id'] ?? 0,
      goalTitle: json['goal_title'] ?? '',   // ✅ null-safe
      startDate: json['start_date'] ?? '',   // ✅ null-safe
      targetDate: json['target_date'] ?? '', // ✅ null-safe
      status: json['status'] ?? '',           // ✅ null-safe
      notes: json['notes'] ?? '',             // ✅ null-safe
    );
  }
}
