import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Payment {
  final int id;
  final int amount;
  final String paymentDate;
  final String paymentMethod;
  final String status;
  final int parentId;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.status,
    required this.parentId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount'],
      paymentDate: json['payment_date'],
      paymentMethod: json['payment_method'],
      status: json['status'],
      parentId: json['parent_id'],
    );
  }
}
class PaymentItem extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;

  const PaymentItem({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(payment.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID-${payment.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.paymentDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA0A0A0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              payment.status.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
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

