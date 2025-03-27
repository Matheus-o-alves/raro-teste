import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/constants/enum.dart'; 
import '../../bloc/payments_bloc/payments_bloc.dart';
import '../../bloc/payments_bloc/payments_event.dart';

/// Caso você ainda não tenha `alwaysVisibleOptions` definido em outro lugar,
/// você pode declarar localmente. Ajuste conforme suas opções fixas:
const List<TransactionDetailOption> alwaysVisibleOptions = [
  TransactionDetailOption.processDate,
  TransactionDetailOption.amount,
  TransactionDetailOption.type,
];

Future<void> showTransactionFilterBottomSheet(
  BuildContext context,
  List<TransactionDetailOption> initialOptions,
) async {
  final bloc = context.read<PaymentsBloc>();
  final selected = [...initialOptions]; // cópia mutável

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
                  // Título + botão de fechar
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

                  // Lista de checkboxes
                  ...TransactionDetailOption.values.map((option) {
                    final isFixed = alwaysVisibleOptions.contains(option);
                    final isChecked = selected.contains(option) || isFixed;

                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(
                        _getOptionLabel(option),
                        style: TextStyle(
                          color: isFixed ? Colors.grey : Colors.black,
                        ),
                      ),
                      activeColor: isFixed ? Colors.grey : Colors.green,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: isFixed
                          ? null // Desabilita interação se for fixo
                          : (_) {
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

  // Ao fechar o BottomSheet, dispara o evento para atualizar o estado do Bloc
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

