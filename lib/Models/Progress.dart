class Progress {
  final int id;
  final int childId;
  final int classroomId;
  final String goalTitle;
  final String startDate;
  final String targetDate;
  final String status;
  final String notes;

  Progress({
    required this.id,
    required this.childId,
    required this.classroomId,
    required this.goalTitle,
    required this.startDate,
    required this.targetDate,
    required this.status,
    required this.notes,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      childId: json['child_id'],
      classroomId: json['classroom_id'],
      goalTitle: json['goal_title'],
      startDate: json['start_date'],
      targetDate: json['target_date'],
      status: json['status'],
      notes: json['notes'],
    );
  }
}
