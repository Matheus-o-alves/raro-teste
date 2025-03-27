import 'package:equatable/equatable.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import '../../../../../core/base/constants/enum.dart';
import 'payments_event.dart';

enum PaymentsStatus { initial, loading, loaded, error }

class PaymentsState extends Equatable {
  final PaymentsTab selectedTab;
  final PaymentsStatus status;
  final PaymentsInfoEntity? paymentsInfo;
  final String? errorMessage;
  final List<TransactionDetailOption> visibleOptions;

  const PaymentsState({
    required this.selectedTab,
    this.status = PaymentsStatus.initial,
    this.paymentsInfo,
    this.errorMessage,
    this.visibleOptions = const [],
  });

  PaymentsState copyWith({
    PaymentsTab? selectedTab,
    PaymentsStatus? status,
    PaymentsInfoEntity? paymentsInfo,
    String? errorMessage,
    List<TransactionDetailOption>? visibleOptions,
  }) {
    final updatedVisibleOptions = {
      ...?visibleOptions ?? this.visibleOptions,
      ...alwaysVisibleOptions, // força os fixos
    }.toList();

    return PaymentsState(
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      paymentsInfo: paymentsInfo ?? this.paymentsInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      visibleOptions: updatedVisibleOptions,
    );
  }

  @override
  List<Object?> get props =>
      [selectedTab, status, paymentsInfo, errorMessage, visibleOptions];
}
