import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../navbar.dart';

class AttendanceDatePage extends StatefulWidget {
  const AttendanceDatePage({super.key});

  @override
  State<AttendanceDatePage> createState() => _AttendanceDatePageState();
}

class _AttendanceDatePageState extends State<AttendanceDatePage> {
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

  int selectedDay = 15;
  String monthYear = "November 2023";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
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

            // Calendar Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Month Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _navButton(Icons.chevron_left),
                        Text(
                          monthYear,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        _navButton(Icons.chevron_right),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Week Days
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

                    // Days Grid
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
                        final day = index - 2; // offset for previous month
                        final isCurrentMonth =
                            day >= 1 && day <= 30;

                        if (!isCurrentMonth) {
                          return _DayCell(
                            text: day <= 0
                                ? "${29 + day}"
                                : "${day - 30}",
                            muted: true,
                          );
                        }

                        return _DayCell(
                          text: "$day",
                          selected: day == selectedDay,
                          onTap: () {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.05),
        shape: const CircleBorder(),
      ),
    );
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
  final bool muted;
  final VoidCallback? onTap;

  const _DayCell({
    required this.text,
    this.selected = false,
    this.muted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: muted ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF3B82F6)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: muted
                ? Colors.grey
                : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
