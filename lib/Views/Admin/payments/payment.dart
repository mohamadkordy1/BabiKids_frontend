import 'package:flutter/material.dart';
import 'package:frontend/Controllers/UserController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/User.dart';
import '../../../Controllers/PaymentController.dart';
import 'EditPaymentPage.dart';
import 'CreatePayment.dart';

class ShowPaymentPage extends StatelessWidget {
  const ShowPaymentPage({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primary = Color(0xFF3B82F6);
    const Color backgroundDark = Color(0xFF111418);
    const Color surfaceDark = Color(0xFF1C2026);
    const Color textSecondary = Color(0xFF9CA3AF);

    final PaymentController paymentController = Get.put(PaymentController());

    // Fetch payments for this user
    paymentController.fetchPaymentsForUser(user.id);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // HEADER
                  Row(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parent',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primary,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            user.name,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // PAYMENTS LIST
                  Expanded(
                    child: Obx(() {
                      if (paymentController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final payments = paymentController.payments
                          .where((p) => p.parentId == user.id)
                          .toList();

                      if (payments.isEmpty) {
                        return Center(
                          child: Text(
                            'No payments found',
                            style: GoogleFonts.inter(color: Colors.white54),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final p = payments[index];
                          Color statusColor;
                          IconData statusIcon;

                          switch (p.status.toLowerCase()) {
                            case 'paid':
                              statusColor = const Color(0xFF22C55E);
                              statusIcon = Icons.check_circle;
                              break;
                            case 'pending':
                              statusColor = const Color(0xFFEAB308);
                              statusIcon = Icons.schedule;
                              break;
                            case 'overdue':
                              statusColor = const Color(0xFFEF4444);
                              statusIcon = Icons.error;
                              break;
                            default:
                              statusColor = Colors.grey;
                              statusIcon = Icons.info;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                // Navigate to EditPaymentPage
                                Get.to(() => EditPaymentPage(payment: p,token: UserController().accessToken.value,
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: surfaceDark,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: p.status.toLowerCase() == 'overdue'
                                        ? statusColor.withOpacity(0.2)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(statusIcon, color: statusColor),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$${p.amount}',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              p.paymentDate,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Row(
                                        children: [
                                          Icon(statusIcon, color: statusColor, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            p.status,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: statusColor,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            // FLOATING ADD BUTTON
            Positioned(
              bottom: 28,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => AddPaymentPage(user: user));
                },
                backgroundColor: primary,
                child: const Icon(Icons.add, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
