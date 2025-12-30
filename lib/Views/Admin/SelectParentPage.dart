import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../Controllers/UserController.dart';
import '../../Models/User.dart';
import '../Admin/admin_navbar/AppBottomNav.dart';
import 'package:frontend/Views/Admin/AdminActionsPage.dart';
class SelectParentPage extends StatefulWidget {
  const SelectParentPage({super.key});

  @override
  State<SelectParentPage> createState() => _SelectParentPageState();
}

class _SelectParentPageState extends State<SelectParentPage> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController searchController = TextEditingController();

  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDark = Color(0xFF1C2026);
  static const Color textSecondary = Color(0xFF9CA3AF);

  List<User> filteredParents = [];

  @override
  void initState() {
    super.initState();

    // Fetch parents from API
    userController.fetchParents().then((_) {
      setState(() {
        filteredParents = userController.parents;
      });
    });

    // Listen to search field
    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      setState(() {
        filteredParents = userController.parents
            .where((p) => p.email.toLowerCase().contains(query))
            .toList();
      });
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
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Parent',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            /// SEARCH FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: searchController,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by email',
                  hintStyle: GoogleFonts.inter(color: textSecondary),
                  prefixIcon: const Icon(Icons.search, color: textSecondary),
                  filled: true,
                  fillColor: surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// PARENT LIST
            Expanded(
              child: Obx(() {
                if (userController.isLoadingParents.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: primary));
                }

                if (filteredParents.isEmpty) {
                  return Center(
                    child: Text(
                      'No parents found',
                      style: GoogleFonts.inter(color: textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredParents.length,
                  itemBuilder: (context, index) {
                    final User parent = filteredParents[index];
                    final initials = parent.name
                        .trim()
                        .split(' ')
                        .take(2)
                        .map((e) => e[0])
                        .join()
                        .toUpperCase();
                    return _parentTile(
                      parent: filteredParents[index],

                      color: primary,
                    );
                  },
                );
              }),
            ),

            /// BOTTOM NAV
            const AppBottomNav(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _parentTile({
    required User parent,   // pass the whole User
    required Color color,
  }) {
    final initials = parent.name
        .trim()
        .split(' ')
        .take(2)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Navigate and pass user
            Get.to(() => AdminActionsPage(user: parent));
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parent.name,
                          style: GoogleFonts.inter(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(parent.email,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
