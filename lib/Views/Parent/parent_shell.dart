import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'parent_home.dart';
import '../parentNav/Payment/payments.dart';
import '../parentNav/Reports/Reports.dart';
import '../parentNav/Settings/Settings.dart';
import '../../controllers/parent_nav_controller.dart';

class ParentShell extends StatelessWidget {
  ParentShell({super.key});

  final ParentNavController nav = Get.put(ParentNavController());

  final pages = [
    const ParentHome(),
    const PaymentPage(),
    const ReportsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      body: Obx(() => pages[nav.currentIndex.value]),

      bottomNavigationBar: Obx(
            () => Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF0C0E10),
            border: Border(
              top: BorderSide(color: Color(0x1AFFFFFF)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.dashboard, "Dashboard", 0),
              _navItem(Icons.credit_card, "Payments", 1),
              _navItem(Icons.analytics, "Reports", 2),
              _navItem(Icons.settings, "Settings", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = nav.currentIndex.value == index;

    return GestureDetector(
      onTap: () => nav.changePage(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFA0A0A0),
            ),
          ),
        ],
      ),
    );
  }
}
