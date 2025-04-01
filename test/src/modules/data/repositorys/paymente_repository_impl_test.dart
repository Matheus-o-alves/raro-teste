import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

import 'paymente_repository_impl_test.mocks.dart';
@GenerateMocks([PaymentsDataSource])

void main() {
  late MockPaymentsDataSource mockDataSource;
  late PaymentsRepositoryImpl repository;
  late PaymentsInfoEntity testPaymentsInfo;

  setUp(() {
    mockDataSource = MockPaymentsDataSource();
    repository = PaymentsRepositoryImpl(mockDataSource);

  
    testPaymentsInfo = TestPaymentsInfoEntity(
      transactions: [],
      transactionFilter: [],
      paymentsScheduled: [],
      summary: [],
    );
  });

  group('PaymentsRepositoryImpl', () {
    test('deve retornar PaymentsInfoEntity quando a chamada ao datasource é bem-sucedida', () async {
      when(mockDataSource.getPaymentsInfo())
          .thenAnswer((_) async => testPaymentsInfo);

      final result = await repository.getPayments();

      expect(result, Right(testPaymentsInfo));
      verify(mockDataSource.getPaymentsInfo()).called(1);
    });

    test('deve retornar GenericFailure quando a chamada ao datasource falha', () async {
      final testException = Exception('Erro de teste');
      when(mockDataSource.getPaymentsInfo())
          .thenThrow(testException);


      final result = await repository.getPayments();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericFailure>());
          expect(failure.error, testException);
        },
        (_) => fail('Não deveria retornar Right'),
      );
      verify(mockDataSource.getPaymentsInfo()).called(1);
    });
  });
}

class TestPaymentsInfoEntity extends PaymentsInfoEntity {
  const TestPaymentsInfoEntity({
    required super.transactions,
    required super.transactionFilter,
    required super.paymentsScheduled,
    required super.summary,
  });
}