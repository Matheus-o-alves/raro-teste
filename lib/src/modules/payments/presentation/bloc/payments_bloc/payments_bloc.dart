import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/base/constants/enum.dart';
import '../../../domain/entity/detail_row_entity.dart';
import 'payments_event.dart';
import 'payments_state.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase getPaymentsUseCase;

  PaymentsBloc(this.getPaymentsUseCase)
      : super(const PaymentsState(
          selectedTab: PaymentsTab.Payments,
        )) {
    on<PaymentsTabChanged>((event, emit) {
      emit(state.copyWith(selectedTab: event.tab));
    });

    on<LoadPaymentsEvent>((event, emit) async {
      emit(state.copyWith(status: PaymentsStatus.loading));

      final result = await getPaymentsUseCase();
      result.fold(
        (failure) => emit(state.copyWith(
          status: PaymentsStatus.error,
          errorMessage: failure.message,
        )),
        (paymentsInfo) => emit(state.copyWith(
          status: PaymentsStatus.loaded,
          paymentsInfo: paymentsInfo,
          transactionFilter: paymentsInfo.transactionFilter,
          activeTransactionFilterKeys: paymentsInfo.transactionFilter
              .where((f) => f.isDefault)
              .map((f) => f.key)
              .toList(),
        )),
      );
    });

    on<UpdateTransactionFilterKeys>((event, emit) {
      emit(state.copyWith(activeTransactionFilterKeys: event.selectedKeys));
    });
  }

  List<PaymentsTransactionsEntity> getFilteredTransactions() {
    final all = state.paymentsInfo?.transactions ?? [];
    final filters = state.activeTransactionFilterKeys;
    return all.where((tx) => filters.contains(tx.paymentType)).toList();
  }

 List<DetailRowData> getTransactionDetailRows(PaymentsTransactionsEntity transaction) {
  final effectiveOptions = state.activeTransactionFilterKeys;

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String formatCurrency(double value) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);

  List<DetailRowData> rows = [];

  // Ajustado para usar as chaves conforme o mock
  final showProcessDate = effectiveOptions.contains("processDate");
  final showAmount = effectiveOptions.contains("actualPaymentAmount");
  if (showProcessDate || showAmount) {
    rows.add(DetailRowData(
      leftLabel: showProcessDate ? 'Process date' : '',
      leftValue: showProcessDate ? formatDate(transaction.processDate) : '',
      rightLabel: showAmount ? 'Amount' : '',
      rightValue: showAmount ? formatCurrency(transaction.actualPaymentAmount) : '',
    ));
  }

  final showType = effectiveOptions.contains("type");
  final showPrincipal = effectiveOptions.contains("actualPrincipalPaymentAmount");
  if (showType || showPrincipal) {
    rows.add(DetailRowData(
      leftLabel: showType ? 'Type' : '',
      leftValue: showType ? transaction.paymentType : '',
      rightLabel: showPrincipal ? 'Principal' : '',
      rightValue: showPrincipal ? formatCurrency(transaction.actualPrincipalPaymentAmount) : '',
    ));
  }

  final showLateFee = effectiveOptions.contains("actualFee");
  final showInterest = effectiveOptions.contains("actualInterestPaymentAmount");
  if (showLateFee || showInterest) {
    rows.add(DetailRowData(
      leftLabel: showLateFee ? 'Late Fee' : '',
      leftValue: showLateFee ? (transaction.actualFee > 0 ? formatCurrency(transaction.actualFee) : '--') : '',
      rightLabel: showInterest ? 'Interest' : '',
      rightValue: showInterest ? formatCurrency(transaction.actualInterestPaymentAmount) : '',
    ));
  }

  final showPrincipalBalance = effectiveOptions.contains("outstandingPrincipalBalance");
  final showPostDate = effectiveOptions.contains("actualPaymentPostDate");
  if (showPrincipalBalance || showPostDate) {
    rows.add(DetailRowData(
      leftLabel: showPrincipalBalance ? 'Principal Balance' : '',
      leftValue: showPrincipalBalance ? formatCurrency(transaction.outstandingPrincipalBalance) : '',
      rightLabel: showPostDate ? 'Post date' : '',
      rightValue: showPostDate ? formatDate(transaction.actualPaymentPostDate) : '',
    ));
  }

  return rows;
}

}
