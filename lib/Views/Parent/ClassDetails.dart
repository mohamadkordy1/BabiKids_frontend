import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '/Models/Classroom.dart';
import '../../Controllers/AttandanceController.dart';
  import 'package:frontend/Models/Child.dart';
class ClassroomDetailPage extends StatefulWidget {
  final Classroom classroom;
  final Child child;

  const ClassroomDetailPage({super.key, required this.classroom, required this.child});

  @override
  State<ClassroomDetailPage> createState() => _ClassroomDetailPageState();
}

class _ClassroomDetailPageState extends State<ClassroomDetailPage> {
  final AttendanceController attendanceController = Get.put(AttendanceController());

  final int totalDays = 30; // Example for September

  @override
  void initState() {
    super.initState();
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
        child: Obx(() {
          final percent = attendanceController.presentPercentage(totalDays);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Classroom info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.classroom.name,
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text("Time: ${widget.classroom.startTime} - ${widget.classroom.endTime}",
                        style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text("Teacher: ${widget.classroom.teacher}",
                        style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text("Child: ${widget.child.name}",
                        style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),

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
      ),
    );
  }
}
