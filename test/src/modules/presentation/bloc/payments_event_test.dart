import 'package:base_project/src/modules/payments/presentation/page/presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsEvent', () {
    group('PaymentsTabChanged', () {
      test('suporta comparação de valores', () {
        expect(
          const PaymentsTabChanged(PaymentsTab.payments),
          const PaymentsTabChanged(PaymentsTab.payments),
        );
        
        expect(
          const PaymentsTabChanged(PaymentsTab.payments),
          isNot(equals(const PaymentsTabChanged(PaymentsTab.transactions))),
        );
      });

      test('props contém valores necessários para comparação', () {
        expect(
          const PaymentsTabChanged(PaymentsTab.payments).props,
          [PaymentsTab.payments],
        );
      });
    });

    group('LoadPaymentsEvent', () {
      test('instâncias distintas são iguais', () {
        expect(
          LoadPaymentsEvent(),
          LoadPaymentsEvent(),
        );
      });

      test('props retorna lista vazia', () {
        expect(
          LoadPaymentsEvent().props,
          [],
        );
      });
    });

    group('UpdateTransactionFilterKeys', () {
      test('suporta comparação de valores', () {
        expect(
          const UpdateTransactionFilterKeys(['key1', 'key2']),
          const UpdateTransactionFilterKeys(['key1', 'key2']),
        );
        
        expect(
          const UpdateTransactionFilterKeys(['key1', 'key2']),
          isNot(equals(const UpdateTransactionFilterKeys(['key1']))),
        );
      });

      test('props contém valores necessários para comparação', () {
        const filterKeys = ['filter1', 'filter2'];
        expect(
          const UpdateTransactionFilterKeys(filterKeys).props,
          [filterKeys],
        );
      });
    });
  });
}