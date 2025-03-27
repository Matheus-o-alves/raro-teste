import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/constants/enum.dart';
import '../../bloc/payments_bloc/payments_bloc.dart';
import '../../bloc/payments_bloc/payments_event.dart';

Future<void> showTransactionFilterBottomSheet(BuildContext context, List<TransactionDetailOption> initialOptions) async {
  final bloc = context.read<PaymentsBloc>();
  final selected = [...initialOptions];

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Additional information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...TransactionDetailOption.values.map((option) {
                    final isChecked = selected.contains(option);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(_getOptionLabel(option)),
                      activeColor: Colors.green,
                      onChanged: (_) {
                        setState(() {
                          isChecked
                              ? selected.remove(option)
                              : selected.add(option);
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  bloc.add(UpdateTransactionDetailOptions(selected));
}

String _getOptionLabel(TransactionDetailOption option) {
  switch (option) {
    case TransactionDetailOption.processDate:
      return 'Process Date';
    case TransactionDetailOption.amount:
      return 'Amount';
    case TransactionDetailOption.type:
      return 'Type';
    case TransactionDetailOption.principal:
      return 'Principal';
    case TransactionDetailOption.interest:
      return 'Interest';
    case TransactionDetailOption.lateFee:
      return 'Late Fee';
    case TransactionDetailOption.postDate:
      return 'Post Date';
    case TransactionDetailOption.principalBalance:
      return 'Principal Balance';
  }
}
