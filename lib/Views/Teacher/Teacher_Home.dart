import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:get/get.dart';
import 'package:frontend/Controllers/ClassroomController.dart';
import 'Classroom.dart';
import 'CreateClass.dart';
import 'navbar.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardBackground = Color(0xFF1F2937);

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}
final UserController controller = Get.put(UserController());

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final ClassroomController classroomController =
  Get.put(ClassroomController());


  @override
  void initState() {
    super.initState();
    classroomController.fetchClassrooms();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeacherDashboardPage.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Welcome ${controller.user.value?.name ?? ""}',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Create Class Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {

                          final user = controller.user.value;
                          if (user != null) {
                            Get.to(() => CreateClassPage(user: user));
                          } else {
                            Get.snackbar('Error', 'User not found');
                          }



                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TeacherDashboardPage.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                        label: Text(
                          'Create New Class',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'My Classes',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Class List
                  Expanded(
                    child: Obx(() {
                      if (classroomController.classrooms.isEmpty) {
                        return const Center(
                          child: Text(
                            'No classes created yet',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: classroomController.classrooms.length,
                        itemBuilder: (context, index) {
                          final classroom = classroomController.classrooms[index];

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => ClassDetailsPage(
                                classroom: classroom,
                              ));
                            },
                            child: ClassCard(
                              title: classroom.name,
                              subtitle: '${classroom.children.length} Students',
                            ),
                          );

                        },
                      );
                    }),
                  ),

                ],
              ),
            ),

            // Bottom Navigation


          ],
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 0), );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ClassCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeacherDashboardPage.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TeacherDashboardPage.primary.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: TeacherDashboardPage.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: TeacherDashboardPage.primary),
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
                    color: TeacherDashboardPage.primary,

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
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: TeacherDashboardPage.backgroundDark,
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            active: true,
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            active: false,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? TeacherDashboardPage.primary
        : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
