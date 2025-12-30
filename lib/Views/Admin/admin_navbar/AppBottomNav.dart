import 'package:flutter/material.dart';
import 'package:frontend/Views/Admin/SelectParentPage.dart';
import 'package:frontend/Views/Admin/UserRole/ManageUserRolesPage.dart';
import 'package:frontend/Views/Admin/admin_navbar/adminSettings.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDarkHover = Color(0xFF2A2F36);
  static const Color textSecondary = Color(0xFF9CA3AF);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const SelectParentPage();
        break;
      case 1:
        page = const ManageUserRolesPage();
        break;
      case 2:
        page =  SettingsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: backgroundDark,
        border: Border(
          top: BorderSide(color: surfaceDarkHover),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: Icons.person_add,
            label: 'Select Parent',
            active: currentIndex == 0,
            onTap: () => _onTap(context, 0),
          ),
          _NavItem(
            icon: Icons.admin_panel_settings,
            label: 'Manage Role',
            active: currentIndex == 1,
            onTap: () => _onTap(context, 1),
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            active: currentIndex == 2,
            onTap: () => _onTap(context, 2),
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
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  static const Color primary = Color(0xFF3B82F6);
  static const Color textSecondary = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 40,
            width: 48,
            decoration: BoxDecoration(
              color: active
                  ? primary.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: active ? primary : textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ).copyWith(
              color: active ? primary : textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
