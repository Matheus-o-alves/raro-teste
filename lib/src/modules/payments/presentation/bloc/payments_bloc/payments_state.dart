import 'package:equatable/equatable.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'payments_event.dart';


// Single Responsibility: State container for the payments feature
class PaymentsState extends Equatable {
  final PaymentsTab selectedTab;
  final PaymentsStatus status;
  final PaymentsInfoEntity? paymentsInfo;
  final String? errorMessage;
  final List<String> activeTransactionFilterKeys;
  final List<PaymentsTransactionFilterEntity> transactionFilter;

  // Constructor with default values to reduce required parameters
  const PaymentsState({
    required this.selectedTab,
    this.status = PaymentsStatus.initial,
    this.paymentsInfo,
    this.errorMessage,
    this.activeTransactionFilterKeys = const [],
    this.transactionFilter = const [],
  });

  // Immutability: Create new instances instead of modifying existing ones
  PaymentsState copyWith({
    PaymentsTab? selectedTab,
    PaymentsStatus? status,
    PaymentsInfoEntity? paymentsInfo,
    String? errorMessage,
    List<String>? activeTransactionFilterKeys,
    List<PaymentsTransactionFilterEntity>? transactionFilter,
  }) {
    return PaymentsState(
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      paymentsInfo: paymentsInfo ?? this.paymentsInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTransactionFilterKeys:
          activeTransactionFilterKeys ?? this.activeTransactionFilterKeys,
      transactionFilter: transactionFilter ?? this.transactionFilter,
    );
  }

  // For equality checking without comparing object references
  @override
  List<Object?> get props => [
        selectedTab,
        status,
        paymentsInfo,
        errorMessage,
        activeTransactionFilterKeys,
        transactionFilter,
      ];
}

// payments_formatter.dart
// Single Responsibility: Handles formatting of different data types