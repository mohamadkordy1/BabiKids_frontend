import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../Models/User.dart';
import '../../../Controllers/UserController.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key, required this.user});
  final User user;

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? statusValue; // Must select status

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF3B82F6);
    const Color backgroundDark = Color(0xFF111418);
    const Color surfaceDark = Color(0xFF2A2F36);
    const Color textSecondary = Color(0xFF9CA3AF);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add New Payment',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Amount
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                        filled: true,
                        fillColor: surfaceDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primary, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Date
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: surfaceDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primary, width: 2)),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
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
                          dateController.text = '${picked.day}-${picked.month}-${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primary.withOpacity(0.2)),
                      ),
                      child: DropdownButton<String>(
                        value: statusValue,
                        hint: Text('Select Status', style: TextStyle(color: Colors.grey[400])),
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: surfaceDark,
                        icon: const Icon(Icons.expand_more, color: Colors.grey),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        onChanged: (value) {
                          setState(() {
                            statusValue = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: 'paid', child: Text('Paid')),
                          DropdownMenuItem(value: 'pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (amountController.text.isEmpty || dateController.text.isEmpty || statusValue == null) {
                      Get.snackbar('Error', 'Please fill all fields and select status');
                      return;
                    }

                    final token = Get.find<UserController>().accessToken.value;

                    try {
                      final response = await Dio().post(
                        'http://babikids.test/api/v1/payments',
                        data: {
                          'amount': amountController.text,
                          'parent_id': widget.user.id.toString(),
                          'payment_date': dateController.text,
                          'payment_method': 'cash',
                          'status': statusValue!,
                        },
                        options: Options(headers: {
                          'Authorization': 'Bearer $token',
                          'Accept': 'application/json',
                        }),
                      );

                      if (response.statusCode == 200 || response.statusCode == 201) {
                        Get.snackbar('Success', 'Payment created successfully');
                        Navigator.pop(context);
                      } else {
                        Get.snackbar('Error', 'Failed to create payment');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Error adding payment: $e');
                      print('Error adding payment: $e');
                    }
                  },
                  child: Text(
                    'Save Payment',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
