import 'package:flutter/material.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import '../../../Models/Payment.dart';

class EditPaymentPage extends StatefulWidget {
  final Payment payment;
  final String token; // Pass your token here

  const EditPaymentPage({super.key, required this.payment, required this.token});

  @override
  State<EditPaymentPage> createState() => _EditPaymentPageState();
}


class _EditPaymentPageState extends State<EditPaymentPage> {
  late TextEditingController amountController;
  late TextEditingController dateController;
  late String statusValue;
UserController userController= Get.find<UserController>();
  final statusOptions = ['Paid', 'Pending', 'overdue'];
  final paymentMethods = ['cash', 'card', 'bank']; // example

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize amount controller
    amountController =
        TextEditingController(text: widget.payment.amount.toStringAsFixed(2));

    // Initialize date controller
    DateTime parsedDate =
        DateTime.tryParse(widget.payment.paymentDate) ?? DateTime.now();
    dateController = TextEditingController(
        text:
        '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}');

    // Initialize status with exact match from dropdown items
    statusValue = statusOptions.firstWhere(
          (s) => s.toLowerCase() == widget.payment.status.toLowerCase(),
      orElse: () => statusOptions[0],
    );

  }

  Future<void> updatePayment() async {
    setState(() {
      isLoading = true;
    });

    final dio = Dio();
    final url = 'http://babikids.test/api/v1/payments/${widget.payment.id}';

    try {
      final response = await dio.put(
        url,
        data: {
          "amount": amountController.text,
          "parent_id": widget.payment.parentId,
          "payment_date": dateController.text,
          "payment_method": 'cash',
          "status": statusValue.toLowerCase(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userController.accessToken}',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'] ?? 'Payment updated successfully')),
        );
        Navigator.pop(context, true); // Return true to refresh the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update payment')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF3B82F6);
    const Color backgroundDark = Color(0xFF111418);
    const Color surfaceDark = Color(0xFF1C2026);
    const Color textSecondary = Color(0xFF9CA3AF);


    DateTime initialDate =
        DateTime.tryParse(widget.payment.paymentDate) ?? DateTime.now();

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: backgroundDark,
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
                  const SizedBox(width: 12),
                  Text(
                    'Edit Payment',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // MAIN FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Amount
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: textSecondary),
                        filled: true,
                        fillColor: surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        prefixText: '\$ ',
                        prefixStyle: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Date
                    TextFormField(
                      readOnly: true,
                      controller: dateController,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Payment Date',
                        labelStyle: TextStyle(color: textSecondary),
                        filled: true,
                        fillColor: surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.white70),
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dateController.text =
                            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),


                    // Status
                    DropdownButtonFormField<String>(
                      value: statusValue,
                      items: statusOptions
                          .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          statusValue = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        labelStyle: TextStyle(color: textSecondary),
                        filled: true,
                        fillColor: surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                      ),
                      dropdownColor: surfaceDark,
                    ),
                  ],
                ),
              ),
            ),

            // SAVE BUTTON
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updatePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
