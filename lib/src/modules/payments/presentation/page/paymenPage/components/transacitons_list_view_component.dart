import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/payments_bloc/payments_bloc.dart';
import '../../../bloc/payments_bloc/payments_state.dart';
import 'schedule_page.dart/transactions_list_component.dart';


class TransactionsListView extends StatelessWidget {
  const TransactionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
        final transactions = context.watch<PaymentsBloc>().getFilteredTransactions();

        if (transactions.isEmpty) {
          return const Center(child: Text('Nenhuma transação encontrada.'));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return TransactionDetailCard(transaction: transactions[index]);
          },
        );
      },
    );
  }
}
