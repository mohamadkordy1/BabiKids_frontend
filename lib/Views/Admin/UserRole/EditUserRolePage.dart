import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controllers/UserController.dart';
import '../../../Models/User.dart';

class EditUserRolePage extends StatefulWidget {
final User user;
  const EditUserRolePage({
    super.key, required this.user,

  });

  @override
  State<EditUserRolePage> createState() => _EditUserRolePageState();
}

class _EditUserRolePageState extends State<EditUserRolePage> {
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.user.role.toLowerCase();
  }

  // COLORS
  static const Color primary = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF111418);
  static const Color surfaceDark = Color(0xFF1C2026);
  static const Color surfaceDarkHover = Color(0xFF2A2F36);
  static const Color textSecondary = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {




    String initial=  widget.user.name.isNotEmpty
      ? widget.user.name.split(' ').map((e) => e[0]).take(2).join()
      : '?';
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Edit Role',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // USER INFO
                    Column(
                      children: [
                        Container(
                          height: 96,
                          width: 96,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: backgroundDark,
                              width: 4,
                            ),
                          ),
                          child: Text(
                            initial,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.user.name,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current Role: ${widget.user.role}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ROLE SELECTION
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select New Role',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _roleTile(
                      value: 'parent',
                      title: 'Parent',
                      subtitle: 'Can view student progress',
                      icon: Icons.family_restroom,
                      color: Colors.green,
                    ),
                    _roleTile(
                      value: 'teacher',
                      title: 'Teacher',
                      subtitle: 'Can manage assignments',
                      icon: Icons.school,
                      color: Colors.purple,
                    ),
                    _roleTile(
                      value: 'admin',
                      title: 'Admin',
                      subtitle: 'Full access to all settings',
                      icon: Icons.admin_panel_settings,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),

            // SAVE BUTTON
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: backgroundDark,
                border: Border(
                  top: BorderSide(color: surfaceDarkHover),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(

                    onPressed: () async {
                      await Get.find<UserController>().updateUserRoleOnly(
                        user: widget.user,
                        newRole: selectedRole,
                      );

                      Navigator.pop(context);


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ROLE TILE
  Widget _roleTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final bool selected = selectedRole == value;

    return GestureDetector(
      onTap: () => setState(() => selectedRole = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? primary : textSecondary,
                  width: 2,
                ),
                color: selected ? primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
