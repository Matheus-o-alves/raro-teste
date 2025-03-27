import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/base/constants/enum.dart';
import '../../../../domain/domain.dart';
import '../../../bloc/payments_bloc/payments_bloc.dart';

class TransactionDetailCard extends StatelessWidget {
  final PaymentsTransactionsEntity transaction;

  const TransactionDetailCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final visibleOptions = context.select(
      (PaymentsBloc bloc) => bloc.state.visibleOptions,
    );

    final rows = <Widget>[];

    if (visibleOptions.contains(TransactionDetailOption.processDate) &&
        visibleOptions.contains(TransactionDetailOption.amount)) {
      rows.add(_buildDetailRow(
        'Process date',
        _formatDate(transaction.processDate),
        'Amount',
        _formatCurrency(transaction.actualPaymentAmount),
      ));
    }

    if (visibleOptions.contains(TransactionDetailOption.type) &&
        visibleOptions.contains(TransactionDetailOption.principal)) {
      rows.add(_buildDetailRow(
        'Type',
        transaction.paymentType,
        'Principal',
        _formatCurrency(transaction.actualPrincipalPaymentAmount),
      ));
    }

    if (visibleOptions.contains(TransactionDetailOption.lateFee) &&
        visibleOptions.contains(TransactionDetailOption.interest)) {
      rows.add(_buildDetailRow(
        'Late Fee',
        transaction.actualFee > 0
            ? _formatCurrency(transaction.actualFee)
            : '--',
        'Interest',
        _formatCurrency(transaction.actualInterestPaymentAmount),
      ));
    }

    if (visibleOptions.contains(TransactionDetailOption.principalBalance) &&
        visibleOptions.contains(TransactionDetailOption.postDate)) {
      rows.add(_buildDetailRow(
        'Principal Balance',
        _formatCurrency(transaction.outstandingPrincipalBalance),
        'Post date',
        _formatDate(transaction.actualPaymentPostDate),
      ));
    }

    final children = rows
        .expand((row) => [row, const SizedBox(height: 12)])
        .toList();

    if (children.isNotEmpty) {
      children.removeLast(); // remove o último SizedBox extra apenas se existir
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

  Widget _buildDetailRow(
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue,
  ) {
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
