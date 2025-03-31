// payments_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/domain/entity/detail_row_entity.dart';

import 'payments_event.dart';
import 'payments_state.dart';

import 'detail_row_builder.dart';

// Single Responsibility: Handles business logic for payments
class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase getPaymentsUseCase;

  PaymentsBloc(this.getPaymentsUseCase)
      : super(const PaymentsState(
          selectedTab: PaymentsTab.payments,
        )) {
    // Register event handlers
    on<PaymentsTabChanged>(_onTabChanged);
    on<LoadPaymentsEvent>(_onLoadPayments);
    on<UpdateTransactionFilterKeys>(_onUpdateFilterKeys);
  }

  // Dependency Inversion: Uses abstract interfaces instead of concrete implementations
  void _onTabChanged(PaymentsTabChanged event, Emitter<PaymentsState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  // Single Responsibility: Each method handles one specific event
  Future<void> _onLoadPayments(LoadPaymentsEvent event, Emitter<PaymentsState> emit) async {
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
  }

  void _onUpdateFilterKeys(UpdateTransactionFilterKeys event, Emitter<PaymentsState> emit) {
    emit(state.copyWith(activeTransactionFilterKeys: event.selectedKeys));
  }

  // Public API methods for UI components
  
  // Gets filtered transactions based on active filter keys
  List<PaymentsTransactionsEntity> getFilteredTransactions() {
    final all = state.paymentsInfo?.transactions ?? [];
    final filters = state.activeTransactionFilterKeys;
    return all.where((tx) => filters.contains(tx.paymentType)).toList();
  }

  // Uses DetailRowBuilder to build transaction detail rows
  List<DetailRowData> getTransactionDetailRows(PaymentsTransactionsEntity transaction) {
    final detailRowBuilder = DetailRowBuilder(state.activeTransactionFilterKeys);
    return detailRowBuilder.buildRows(transaction);
  }
}