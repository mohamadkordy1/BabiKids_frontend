import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Teacher_Home.dart';
import 'TeacherSettings.dart';

class TeacherBottomNav extends StatelessWidget {
  final int currentIndex;

  const TeacherBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTap(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Get.off(() => const TeacherDashboardPage());
    } else if (index == 1) {
      Get.off(() => SettingsPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onTap,
      backgroundColor: const Color(0xFF111827),
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
