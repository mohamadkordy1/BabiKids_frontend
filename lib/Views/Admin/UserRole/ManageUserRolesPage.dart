import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/UserController.dart';
import '../../../Models/User.dart';
import '../admin_navbar/AppBottomNav.dart';
import 'EditUserRolePage.dart';

class ManageUserRolesPage extends StatefulWidget {
  const ManageUserRolesPage({super.key});

  @override
  State<ManageUserRolesPage> createState() => _ManageUserRolesPageState();
}

class _ManageUserRolesPageState extends State<ManageUserRolesPage> {
  final UserController userController = Get.find<UserController>();

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDark = Color(0xFF1C2026);
  static const Color textSecondary = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    userController.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Manage User Roles',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // CONTENT
            Expanded(
              child: Obx(() {
                if (userController.isLoadingUsers.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                if (userController.allUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(color: textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: userController.allUsers.length,
                  itemBuilder: (context, index) {
                    final user = userController.allUsers[index];
                    return _userTile(user);
                  },
                );
              }),
            ),

            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  // USER TILE
  Widget _userTile(User user) {
    final color = _roleColor(user.role);
    final initials = user.name.isNotEmpty
        ? user.name.split(' ').map((e) => e[0]).take(2).join()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // 👉 NEXT PAGE (edit user)
          Get.to(() => EditUserRolePage(user: user));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.role,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'teacher':
        return Colors.purple;
      case 'parent':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
