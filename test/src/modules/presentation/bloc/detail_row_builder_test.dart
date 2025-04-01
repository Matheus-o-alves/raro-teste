import 'package:base_project/src/modules/payments/presentation/page/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

import '../../../../utils/contrete_entitys.dart';

void main() {
  group('DetailRowBuilder', () {
    late PaymentsTransactionsEntity mockTransaction;

    setUp(() {
      mockTransaction = ConcretePaymentsTransactionsEntity(
        key: 'txn2',
        paymentType: 'filter2',
        processDate: DateTime(2023, 2, 1),
        actualPaymentAmount: 200.0,
        actualPrincipalPaymentAmount: 160.0,
        actualFee: 10.0,
        actualInterestPaymentAmount: 30.0,
        outstandingPrincipalBalance: 700.0,
        outstandingLoanBalance: 800.0,
        actualPaymentPostDate: DateTime(2023, 2, 2),
      );
    });

    test('buildRows retorna lista vazia quando não há filtros ativos', () {
      final builder = DetailRowBuilder([]);
      final rows = builder.buildRows(mockTransaction);
      expect(rows, isEmpty);
    });

    test(
      '_addProcessDateAndAmountRow adiciona linha quando os filtros relevantes estão ativos',
      () {
        final builder = DetailRowBuilder([
          'processDate',
          'actualPaymentAmount',
        ]);
        final rows = builder.buildRows(mockTransaction);

        expect(rows.length, greaterThanOrEqualTo(1));
        expect(rows[0].leftLabel, equals('Process date'));
        expect(rows[0].leftValue, isNotEmpty);
        expect(rows[0].rightLabel, equals('Amount'));
        expect(rows[0].rightValue, isNotEmpty);
      },
    );

    test(
      '_addProcessDateAndAmountRow adiciona linha parcial quando apenas processDate está ativo',
      () {
        final builder = DetailRowBuilder(['processDate']);
        final rows = builder.buildRows(mockTransaction);

        expect(rows.length, greaterThanOrEqualTo(1));
        expect(rows[0].leftLabel, equals('Process date'));
        expect(rows[0].leftValue, isNotEmpty);
        expect(rows[0].rightLabel, isEmpty);
        expect(rows[0].rightValue, isEmpty);
      },
    );

    test(
      '_addProcessDateAndAmountRow adiciona linha parcial quando apenas actualPaymentAmount está ativo',
      () {
        final builder = DetailRowBuilder(['actualPaymentAmount']);
        final rows = builder.buildRows(mockTransaction);

        expect(rows.length, greaterThanOrEqualTo(1));
        expect(rows[0].leftLabel, isEmpty);
        expect(rows[0].leftValue, isEmpty);
        expect(rows[0].rightLabel, equals('Amount'));
        expect(rows[0].rightValue, isNotEmpty);
      },
    );

    test(
      '_addTypeAndPrincipalRow adiciona linha quando os filtros relevantes estão ativos',
      () {
        final builder = DetailRowBuilder([
          'type',
          'actualPrincipalPaymentAmount',
        ]);
        final rows = builder.buildRows(mockTransaction);

        final rowIndex = rows.indexWhere(
          (row) => row.leftLabel == 'Type' || row.rightLabel == 'Principal',
        );

        expect(rowIndex, isNot(-1));
        expect(rows[rowIndex].leftLabel, equals('Type'));
        expect(rows[rowIndex].leftValue, equals(mockTransaction.paymentType));
        expect(rows[rowIndex].rightLabel, equals('Principal'));
        expect(rows[rowIndex].rightValue, isNotEmpty);
      },
    );

    test(
      '_addLateFeeAndInterestRow adiciona linha quando os filtros relevantes estão ativos',
      () {
        final builder = DetailRowBuilder([
          'actualFee',
          'actualInterestPaymentAmount',
        ]);
        final rows = builder.buildRows(mockTransaction);

        final rowIndex = rows.indexWhere(
          (row) => row.leftLabel == 'Late Fee' || row.rightLabel == 'Interest',
        );

        expect(rowIndex, isNot(-1));
        expect(rows[rowIndex].leftLabel, equals('Late Fee'));
        expect(rows[rowIndex].rightValue, isNotEmpty);
      },
    );

    test(
      '_addLateFeeAndInterestRow mostra -- para late fee quando valor é zero',
      () {
        final transactionWithZeroFee = ConcretePaymentsTransactionsEntity(
          key: 'txn2',
          paymentType: 'PAYMENT',
          processDate: DateTime(2023, 5, 15),
          actualPaymentAmount: 150.75,
          actualPrincipalPaymentAmount: 125.50,
          actualFee: 0,
          actualInterestPaymentAmount: 15.00,
          outstandingPrincipalBalance: 1250.00,
          actualPaymentPostDate: DateTime(2023, 5, 16),
          outstandingLoanBalance: 800.0,
        );

        final builder = DetailRowBuilder(['actualFee']);
        final rows = builder.buildRows(transactionWithZeroFee);

        final rowIndex = rows.indexWhere((row) => row.leftLabel == 'Late Fee');
        expect(rowIndex, isNot(-1));
        expect(rows[rowIndex].leftValue, equals('--'));
      },
    );

    test(
      '_addBalanceAndPostDateRow adiciona linha quando os filtros relevantes estão ativos',
      () {
        final builder = DetailRowBuilder([
          'outstandingPrincipalBalance',
          'actualPaymentPostDate',
        ]);
        final rows = builder.buildRows(mockTransaction);

        final rowIndex = rows.indexWhere(
          (row) =>
              row.leftLabel == 'Principal Balance' ||
              row.rightLabel == 'Post date',
        );

        expect(rowIndex, isNot(-1));
        expect(rows[rowIndex].leftLabel, equals('Principal Balance'));
        expect(rows[rowIndex].leftValue, isNotEmpty);
        expect(rows[rowIndex].rightLabel, equals('Post date'));
        expect(rows[rowIndex].rightValue, isNotEmpty);
      },
    );

    test(
      'buildRows adiciona todas as linhas quando todos os filtros estão ativos',
      () {
        final allFilters = [
          'processDate',
          'actualPaymentAmount',
          'type',
          'actualPrincipalPaymentAmount',
          'actualFee',
          'actualInterestPaymentAmount',
          'outstandingPrincipalBalance',
          'actualPaymentPostDate',
        ];

        final builder = DetailRowBuilder(allFilters);
        final rows = builder.buildRows(mockTransaction);

        expect(rows.length, equals(4));
      },
    );
  });
}
