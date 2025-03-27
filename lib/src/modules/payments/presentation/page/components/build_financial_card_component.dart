import 'package:flutter/material.dart';

class BuildFinancialCardComponent extends StatelessWidget {
  const BuildFinancialCardComponent({
    super.key,
    required this.title,
    required this.amount,
  });

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minWidth: 144),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5E646E),
              fontSize: 12,
              letterSpacing: 0.1,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // const Text(
              //   '\$ss',
              //   style: TextStyle(
              //     color: Color(0xFF37404E),
              //     fontSize: 16,
              //     fontWeight: FontWeight.normal,
              //     fontFamily: 'Lato',
              //   ),
              // ),
              Text(
                '\$ ${amount}',
                style: const TextStyle(
                  color: Color(0xFF37404E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
