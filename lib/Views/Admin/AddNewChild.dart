import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Models/User.dart';
import 'package:frontend/Models/Child.dart';
import 'package:frontend/Controllers/ChildrenController.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../Controllers/UserController.dart';
import '../../Core/Network/DioClient.dart';

class AddNewChildPage extends StatefulWidget {
  final User user; // Selected parent
  const AddNewChildPage({super.key, required this.user});

  @override
  State<AddNewChildPage> createState() => _AddNewChildPageState();
}

class _AddNewChildPageState extends State<AddNewChildPage> {
  final _nameController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  final ChildrenController childrenController = Get.find<ChildrenController>();

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primary = Color(0xFF3B82F6);
    const Color backgroundDark = Color(0xFF111418);
    const Color surfaceDark = Color(0xFF1C2026);
    const Color surfaceDarkHover = Color(0xFF2A2F36);
    const Color textSecondary = Color(0xFF9CA3AF);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: [
                  const SizedBox(height: 12),

                  // Header
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: surfaceDark,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Add New Child',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Subtitle
                  Text(
                    "Enter the child's details below to register them in the system.",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  Text(
                    'Full Name',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'e.g. Leo Das',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date of Birth
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2015),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: primary,
                              onPrimary: Colors.white,
                              surface: surfaceDark,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _dob = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dob != null ? '${_dob!.day}-${_dob!.month}-${_dob!.year}' : 'Select date',
                            style: TextStyle(color: _dob != null ? Colors.white : Colors.grey[500], fontWeight: FontWeight.w600),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender
                  Text(
                    'Gender',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primary.withOpacity(0.2)),
                    ),
                    child: DropdownButton<String>(
                      value: _gender,
                      hint: Text('Select gender', style: TextStyle(color: Colors.grey[500])),
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: surfaceDark,
                      icon: const Icon(Icons.expand_more, color: Colors.grey),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Boy')),
                        DropdownMenuItem(value: 'female', child: Text('Girl')),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ADD CHILD BUTTON
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _addChild,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: primary.withOpacity(0.25),
                    elevation: 6,
                  ),
                  child: Text(
                    'Add Child',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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
  Future<void> _addChild() async {
    if (_nameController.text.isEmpty || _dob == null || _gender == null) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      final userController = Get.find<UserController>();
      final token = userController.accessToken.value;

      final response = await DioClient.dio.post(
        '/children',
        data: {
          'name': _nameController.text,
          'date_of_birth': '${_dob!.day}-${_dob!.month}-${_dob!.year}',
          'gender': _gender,
          'parent_id': widget.user.id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // <-- send token
          },
        ),
      );

      final child = Child.fromJson(response.data['child']);

      // Update children controller
      final childrenController = Get.find<ChildrenController>();
      childrenController.children.add(child);

      Get.snackbar('Success', 'Child added successfully');
      Navigator.pop(context); // Go back after adding
    } catch (e) {
      print('Error adding child: $e');
      Get.snackbar('Error', 'Failed to add child');
    }
  }

}
