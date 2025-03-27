import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/base/constants/enum.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/entity/detail_row_entity.dart';
import '../../../bloc/payments_bloc/payments_bloc.dart';
import '../../../bloc/payments_bloc/payments_state.dart';

class TransactionDetailCard extends StatelessWidget {
  final PaymentsTransactionsEntity transaction;

  const TransactionDetailCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = context.read<PaymentsBloc>().getTransactionDetailRows(transaction);

    final children = rows.where((r) => !r.isEmpty).expand((row) => [
      _buildDetailRow(row),
      const SizedBox(height: 12),
    ]).toList();

    if (children.isNotEmpty) {
      children.removeLast();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(DetailRowData row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: row.leftLabel.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.leftLabel, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(height: 4),
                    Text(row.leftValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: row.rightLabel.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.rightLabel, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(height: 4),
                    Text(row.rightValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
