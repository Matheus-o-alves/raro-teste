import 'package:base_project/src/modules/payments/domain/domain.dart';

class ConcretePaymentsTransactionsEntity extends PaymentsTransactionsEntity {
  const ConcretePaymentsTransactionsEntity({
    required super.key,
    required super.actualPaymentPostDate,
    required super.processDate,
    required super.actualPaymentAmount,
    required super.actualPrincipalPaymentAmount,
    required super.actualInterestPaymentAmount,
    required super.outstandingPrincipalBalance,
    required super.outstandingLoanBalance,
    required super.actualFee,
    required super.paymentType,
  });

  @override
  Map<String, dynamic> toMap() {
    throw UnsupportedError('Método toMap() não implementado para testes');
  }
}

class ConcretePaymentsInfoEntity extends PaymentsInfoEntity {
  const ConcretePaymentsInfoEntity({
    required super.paymentsScheduled,
    required super.summary,
    required super.transactionFilter,
    required super.transactions,
  });
}

class ConcreteFilterEntity extends PaymentsTransactionFilterEntity {
  const ConcreteFilterEntity({
    required super.key,
    required super.label,
    required super.isDefault,
  });
}