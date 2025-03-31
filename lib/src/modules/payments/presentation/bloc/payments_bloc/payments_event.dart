import 'package:equatable/equatable.dart';

enum PaymentsTab { payments, transactions }

enum PaymentsStatus { initial, loading, loaded, error }

// payments_event.dart

// Open/Closed Principle: Base class for events that can be extended without modification
abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

// Single Responsibility: Each event class handles one specific type of event
class PaymentsTabChanged extends PaymentsEvent {
  final PaymentsTab tab;

  const PaymentsTabChanged(this.tab);

  @override
  List<Object> get props => [tab];
}

class LoadPaymentsEvent extends PaymentsEvent {
  // No additional properties needed
}

class UpdateTransactionFilterKeys extends PaymentsEvent {
  final List<String> selectedKeys;

  const UpdateTransactionFilterKeys(this.selectedKeys);

  @override
  List<Object> get props => [selectedKeys];
}