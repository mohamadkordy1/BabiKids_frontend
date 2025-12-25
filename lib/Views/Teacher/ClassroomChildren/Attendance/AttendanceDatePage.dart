import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../navbar.dart';
import 'Attendance2.dart';
import 'package:frontend/Models/Classroom.dart';
class AttendanceDatePage extends StatefulWidget {
  const AttendanceDatePage({super.key,required this.classroom});

 final Classroom classroom;

  @override
  State<AttendanceDatePage> createState() => _AttendanceDatePageState();
}

class _AttendanceDatePageState extends State<AttendanceDatePage> {
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

  DateTime displayedMonth = DateTime.now();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      "Select Attendance Date",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // SCROLLABLE CALENDAR
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // MONTH + YEAR NAV
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _navButton(Icons.chevron_left, () {
                            setState(() {
                              displayedMonth = DateTime(
                                displayedMonth.year,
                                displayedMonth.month - 1,
                              );
                            });
                          }),
                          Text(
                            "${_monthName(displayedMonth.month)} ${displayedMonth.year}",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          _navButton(Icons.chevron_right, () {
                            setState(() {
                              displayedMonth = DateTime(
                                displayedMonth.year,
                                displayedMonth.month + 1,
                              );
                            });
                          }),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // WEEKDAYS
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          _WeekDay("Su"),
                          _WeekDay("Mo"),
                          _WeekDay("Tu"),
                          _WeekDay("We"),
                          _WeekDay("Th"),
                          _WeekDay("Fr"),
                          _WeekDay("Sa"),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // DAYS GRID
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 42,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final firstDay = DateTime(
                            displayedMonth.year,
                            displayedMonth.month,
                            1,
                          );
                          final startWeekday = firstDay.weekday % 7;
                          final day = index - startWeekday + 1;
                          final daysInMonth = DateUtils.getDaysInMonth(
                            displayedMonth.year,
                            displayedMonth.month,
                          );

                          if (day < 1 || day > daysInMonth) {
                            return const SizedBox();
                          }

                          final date = DateTime(
                            displayedMonth.year,
                            displayedMonth.month,
                            day,
                          );

                          final isSelected =
                              selectedDate != null &&
                                  selectedDate!.year == date.year &&
                                  selectedDate!.month == date.month &&
                                  selectedDate!.day == date.day;

                          return _DayCell(
                            text: "$day",
                            selected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // SELECTED DATE DISPLAY
                      if (selectedDate != null)
                        Text(
                          _formatFullDate(selectedDate!),
                          style: GoogleFonts.manrope(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // CONTINUE BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedDate == null
                      ? null
                      : () {
                    Get.to(
                          () => DailyAttendancePage(classroom: widget.classroom,
                        selectedDate: selectedDate!,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "View Attendance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.05),
        shape: const CircleBorder(),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  String _formatFullDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }
}

class _WeekDay extends StatelessWidget {
  final String label;
  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _DayCell({
    required this.text,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
