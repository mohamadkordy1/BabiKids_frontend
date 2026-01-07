import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../Controllers/PaymentController.dart';
import '../../../Models/Payment.dart';
import 'paymentDetails.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key});

  final PaymentController controller =
  Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    controller.fetchPayments();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Payment History'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.payments.isEmpty) {
          return const Center(
            child: Text('No payments found',
                style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: controller.payments.length,
            itemBuilder: (context, index) {
              final payment = controller.payments[index];

              return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PaymentItem(
                    payment: payment, // ✅ REQUIRED PARAM FIXED
                    onTap: () {
                      Get.to(() => PaymentDetailsPage(payment: payment));
                    }),
            );
          },
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF22C55E);
      case 'pending':
        return const Color(0xFFEAB308);
      case 'overdue':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }
}

