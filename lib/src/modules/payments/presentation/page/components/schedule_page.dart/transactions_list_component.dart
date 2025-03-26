import 'package:flutter/material.dart';

class TransactionDetailCard extends StatelessWidget {
  const TransactionDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDetailRow('Process date', '02/11/2024', 'Amount', '\$181.12'),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          _buildDetailRow('Type', 'Debit Card', 'Principal', '\$103.29'),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          _buildDetailRow('Late Fee', '--', 'Interest', '\$77.83'),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          _buildDetailRow('Principal Balance', '\$9,066.74', 'Post date', '02/11/2024'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String leftLabel, String leftValue, String rightLabel, String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                leftValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rightLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rightValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}