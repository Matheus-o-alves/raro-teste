import 'package:equatable/equatable.dart';

enum PaymentsTab { Payments, transactions }

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class PaymentsTabChanged extends PaymentsEvent {
  final PaymentsTab tab;

  const PaymentsTabChanged(this.tab);

  @override
  List<Object> get props => [tab];
}


class LoadPaymentsEvent extends PaymentsEvent {}
