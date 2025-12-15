import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/ReportController.dart';
import '../../../Controllers/ChildrenController.dart';
import 'package:frontend/Views/parentNav/Reports/Report2.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ReportController reportController = Get.put(ReportController());
  final ChildrenController childrenController = Get.find<ChildrenController>();

  @override
  void initState() {
    super.initState();
    reportController.fetchReports();
  }

  String getChildName(int childId) {
    final child = childrenController.children.firstWhereOrNull((c) => c.id == childId);
    return child?.name ?? 'Unknown Child';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      body: SafeArea(
        child: Obx(() {
          if (reportController.reports.isEmpty) {
            return const Center(
              child: Text("No reports found", style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reportController.reports.length,
            itemBuilder: (context, index) {
              final report = reportController.reports[index];
              final childName = getChildName(report.childId);

              return FutureBuilder<String>(
                future: reportController.getAuthorName(report.createdBy),
                builder: (context, snapshot) {
                  final authorName = snapshot.data ?? 'Loading...';

                  return GestureDetector(
                    onTap: () {
                      // Navigate to ReportDetailsPage and pass the report
                      Get.to(() => ReportDetailsPage(report: report, childName: childName, authorName: authorName));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            childName,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "By: $authorName",
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${report.reportDate}",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),


    );
  }

  Widget _navItem({required IconData icon, required String label, bool active = false}) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to pages according to label
        print("Navigate to $label");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0)),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0),
            ),
          ),
        ],
      ),
    );
  }
}
