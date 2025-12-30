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
  final TextEditingController searchController = TextEditingController();
  var filteredUsers = <User>[].obs;

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDark = Color(0xFF1C2026);
  static const Color textSecondary = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    userController.fetchAllUsers().then((_) {
      filteredUsers.value = userController.allUsers;
    });

    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredUsers.value = userController.allUsers;
      } else {
        filteredUsers.value = userController.allUsers.where((user) {
          return user.name.toLowerCase().contains(query) ||
              user.role.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
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

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by name or role',
                  hintStyle: TextStyle(color: textSecondary),
                  filled: true,
                  fillColor: surfaceDark,
                  prefixIcon: const Icon(Icons.search, color: textSecondary),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // USER LIST
            Expanded(
              child: Obx(() {
                if (userController.isLoadingUsers.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(color: textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
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
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
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
