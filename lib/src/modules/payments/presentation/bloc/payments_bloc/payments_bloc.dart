import 'package:flutter_bloc/flutter_bloc.dart';
import 'payments_event.dart';
import 'payments_state.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:dartz/dartz.dart';

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
  }
}
