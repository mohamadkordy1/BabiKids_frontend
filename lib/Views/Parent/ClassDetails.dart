import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '/Models/Classroom.dart';
import '../../Controllers/AttandanceController.dart';
  import 'package:frontend/Models/Child.dart';
import 'package:get/get.dart';
import '../../Controllers/ProgressController.dart';
import '../../Models/Progress.dart' as model;
import 'package:frontend/Models/Activity.dart';
import 'package:frontend/Controllers/ActivityController.dart';

import 'ActivityDetails.dart';
class ClassroomDetailPage extends StatefulWidget {
  final Classroom classroom;
  final Child child;

  const ClassroomDetailPage({super.key, required this.classroom, required this.child});

  @override
  State<ClassroomDetailPage> createState() => _ClassroomDetailPageState();
}

class _ClassroomDetailPageState extends State<ClassroomDetailPage> {
  final AttendanceController attendanceController = Get.put(AttendanceController());
  final ProgressController progressController = Get.put(ProgressController());
  final ActivityController activityController = Get.put(ActivityController());

  final int totalDays = 30; // Example for September

  @override
  void initState() {
    super.initState();
    progressController.loadProgressForClass(widget.classroom.id);
    activityController.loadActivitiesForClass(widget.classroom.id);
    attendanceController.fetchAttendance(
      classroomId: widget.classroom.id,
      childId: widget.child.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0E10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.classroom.name,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Obx(() {
              final percent = attendanceController.presentPercentage(totalDays);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Classroom info


                  const SizedBox(height: 24),
                  // Attendance
                  Text("Attendance Overview",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1C1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Attendence",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text("${percent.toStringAsFixed(0)}% Present",
                                style: const TextStyle(
                                    color: Color(0xFF3B82F6),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<int>(
                              value: attendanceController.selectedMonth.value,
                              dropdownColor: const Color(0xFF1A1C1E),
                              items: List.generate(12, (index) {
                                final month = index + 1;
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(
                                    month.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  attendanceController.changeMonthYear(
                                    value,
                                    attendanceController.selectedYear.value,
                                  );
                                }
                              },
                            ),

                            DropdownButton<int>(
                              value: attendanceController.selectedYear.value,
                              dropdownColor: const Color(0xFF1A1C1E),
                              items: List.generate(5, (index) {
                                final year = DateTime.now().year - index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    year.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  attendanceController.changeMonthYear(
                                    attendanceController.selectedMonth.value,
                                    value,
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: totalDays,
                          itemBuilder: (context, index) {
                            final day = index + 1;
                            final isPresent = attendanceController.isPresent(day);
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isPresent
                                    ? const Color(0xFF3B82F6).withOpacity(0.3)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$day",
                                style: TextStyle(
                                    color: isPresent ? const Color(0xFF3B82F6) : Colors.grey[400],
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Obx(() {
              if (progressController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (progressController.progresses.isEmpty) {
                return const Text(
                  "No progress added for this class yet",
                  style: TextStyle(color: Colors.white70),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Progress Overview",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...progressController.progresses.map(progressCard).toList(),
                ],
              );
            }),const SizedBox(height: 24),
// Activities Section Title
            const Text(
              'Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 8),

// Activities List
            Obx(() {
              if (activityController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (activityController.activities.isEmpty) {
                return const Text(
                  "No activities for this class yet",
                  style: TextStyle(color: Colors.white70),
                );
              }

              return Column(
                children: activityController.activities.map((a) {
                  // Determine icon based on type (optional)
                  IconData icon = Icons.assignment;
                  if (a.title.toLowerCase().contains('quiz')) {
                    icon = Icons.quiz;
                  } else if (a.title.toLowerCase().contains('group')) {
                    icon = Icons.groups;
                  }
                  return InkWell(
                    onTap: () {
                      // Navigate to details page
                      Get.to(() => ActivityDetailsPage(activity: a));
                    },
                    child: activityCard(
                      icon: icon,
                      title: a.title,
                      subtitle: a.description,
                    ),
                  );

                  return activityCard(
                    icon: icon,
                    title: a.title,
                    subtitle: a.description,
                  );
                }).toList(),
              );
            }),
          ],
        ),

      ),
    );
  }
}





Widget progressCard(model.Progress p) {
  Color statusColor;
  String statusText;

  switch (p.status) {
    case 'completed':
      statusColor = Colors.green;
      statusText = 'Completed';
      break;
    case 'in_progress':
      statusColor = Colors.blue;
      statusText = 'In Progress';
      break;
    default:
      statusColor = Colors.grey;
      statusText = 'Not Started';
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              p.goalTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text("Start: ${p.startDate}",
            style: const TextStyle(color: Colors.white70)),
        Text("Target: ${p.targetDate}",
            style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        Text(
          p.notes,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
Widget activityCard({required IconData icon, required String title, required String subtitle}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1C1E),
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF3B82F6), size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
      ],
    ),
  );
}
