import 'package:equatable/equatable.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'payments_event.dart';


enum PaymentsStatus { initial, loading, loaded, error }

class PaymentsState extends Equatable {
  final PaymentsTab selectedTab;
  final PaymentsStatus status;
  final PaymentsInfoEntity? paymentsInfo;
  final String? errorMessage;

  const PaymentsState({
    required this.selectedTab,
    this.status = PaymentsStatus.initial, // Valor padrão definido aqui
    this.paymentsInfo,
    this.errorMessage,
  });

  PaymentsState copyWith({
    PaymentsTab? selectedTab,
    PaymentsStatus? status,
    PaymentsInfoEntity? paymentsInfo,
    String? errorMessage,
  }) {
    return PaymentsState(
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      paymentsInfo: paymentsInfo ?? this.paymentsInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedTab, status, paymentsInfo, errorMessage];
}
