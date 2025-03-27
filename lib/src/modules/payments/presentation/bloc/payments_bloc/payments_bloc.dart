import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/base/constants/enum.dart';
import '../../../domain/entity/detail_row_entity.dart';
import 'payments_event.dart';
import 'payments_state.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

// Suponha que no seu arquivo de enums você tenha definido:
// enum TransactionDetailOption { processDate, amount, type, principal, lateFee, interest, principalBalance, postDate }
// E também:
const List<TransactionDetailOption> alwaysVisibleOptions = [
  TransactionDetailOption.processDate,
  TransactionDetailOption.amount,
  TransactionDetailOption.type,
];

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase getPaymentsUseCase;

  PaymentsBloc(this.getPaymentsUseCase)
      : super(const PaymentsState(selectedTab: PaymentsTab.Payments)) {
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
        )),
      );
    });

    on<UpdateTransactionDetailOptions>((event, emit) {
      // Garante que os fixos sempre estarão
      final filtered = {
        ...event.selectedOptions,
        ...alwaysVisibleOptions,
      }.toList();
      emit(state.copyWith(visibleOptions: filtered));
    });
  }

// payments_bloc.dart (trecho relevante)
List<DetailRowData> getTransactionDetailRows(PaymentsTransactionsEntity transaction) {
  final effectiveOptions = {
    ...state.visibleOptions,
    ...alwaysVisibleOptions,
  };

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String formatCurrency(double value) => NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);

  List<DetailRowData> rows = [];

  final showProcessDate = effectiveOptions.contains(TransactionDetailOption.processDate);
  final showAmount = effectiveOptions.contains(TransactionDetailOption.amount);
  if (showProcessDate || showAmount) {
    rows.add(DetailRowData(
      leftLabel: showProcessDate ? 'Process date' : '',
      leftValue: showProcessDate ? formatDate(transaction.processDate) : '',
      rightLabel: showAmount ? 'Amount' : '',
      rightValue: showAmount ? formatCurrency(transaction.actualPaymentAmount) : '',
    ));
  }

  final showType = effectiveOptions.contains(TransactionDetailOption.type);
  final showPrincipal = effectiveOptions.contains(TransactionDetailOption.principal);
  if (showType || showPrincipal) {
    rows.add(DetailRowData(
      leftLabel: showType ? 'Type' : '',
      leftValue: showType ? transaction.paymentType : '',
      rightLabel: showPrincipal ? 'Principal' : '',
      rightValue: showPrincipal ? formatCurrency(transaction.actualPrincipalPaymentAmount) : '',
    ));
  }

  final showLateFee = effectiveOptions.contains(TransactionDetailOption.lateFee);
  final showInterest = effectiveOptions.contains(TransactionDetailOption.interest);
  if (showLateFee || showInterest) {
    rows.add(DetailRowData(
      leftLabel: showLateFee ? 'Late Fee' : '',
      leftValue: showLateFee ? (transaction.actualFee > 0 ? formatCurrency(transaction.actualFee) : '--') : '',
      rightLabel: showInterest ? 'Interest' : '',
      rightValue: showInterest ? formatCurrency(transaction.actualInterestPaymentAmount) : '',
    ));
  }

  final showPrincipalBalance = effectiveOptions.contains(TransactionDetailOption.principalBalance);
  final showPostDate = effectiveOptions.contains(TransactionDetailOption.postDate);
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
