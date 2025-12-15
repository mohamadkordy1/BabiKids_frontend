class Report {
  final int id;
  final int childId;
  final String reportDate;
  final String reportType;
  final String content;
  final int createdBy;

  Report({
    required this.id,
    required this.childId,
    required this.reportDate,
    required this.reportType,
    required this.content,
    required this.createdBy,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      childId: json['child_id'],
      reportDate: json['report_date'],
      reportType: json['report_type'],
      content: json['content'],
      createdBy: json['created_by'],
    );
  }
}
