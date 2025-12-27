import 'package:flutter/material.dart';
import 'package:frontend/Models/Classroom.dart';
import 'package:frontend/Views/Teacher/ClassroomChildren/Activity/CreateActivity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../navbar.dart';
import 'ActivityDetails.dart';
import 'package:frontend/Controllers/ActivityController.dart';

class ClassActivitiesPage extends StatelessWidget {
  const ClassActivitiesPage({super.key, required this.classroom});
  final Classroom classroom;

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final ActivityController activityController = Get.put(ActivityController());
    // Load activities for this classroom
    activityController.loadActivitiesForClass(classroom.id);

    return Scaffold(
      backgroundColor: backgroundDark,
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Class Activities",
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

            /// CREATE ACTIVITY BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(CreateActivityPage(classroom: classroom));
                },
                icon: const Icon(Icons.add_circle),
                label: const Text("Create New Activity"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ACTIVITIES LIST
            Expanded(
              child: Obx(() {
                if (activityController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (activityController.activities.isEmpty) {
                  return const Center(
                    child: Text(
                      "No activities found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: activityController.activities.length,
                  itemBuilder: (context, index) {
                    final activity = activityController.activities[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ActivityDetailsPage(activity: activity));
                      },
                      child: _ActivityTile(
                        icon: Icons.quiz,
                        title: activity.title,
                        subtitle: activity.description,
                      ),
                    );
                  },
                );

              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClassActivitiesPage.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: ClassActivitiesPage.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: ClassActivitiesPage.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
