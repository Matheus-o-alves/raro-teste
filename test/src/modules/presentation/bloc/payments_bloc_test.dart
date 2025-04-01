import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/presentation/page/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:base_project/src/modules/payments/domain/domain.dart';

import '../../../../utils/contrete_entitys.dart'
    show
        ConcreteFilterEntity,
        ConcretePaymentsInfoEntity,
        ConcretePaymentsTransactionsEntity;

@GenerateMocks([GetPaymentsUseCase])
import 'payments_bloc_test.mocks.dart';

void main() {
  late MockGetPaymentsUseCase mockGetPaymentsUseCase;
  late PaymentsBloc paymentsBloc;

  setUp(() {
    mockGetPaymentsUseCase = MockGetPaymentsUseCase();
    paymentsBloc = PaymentsBloc(mockGetPaymentsUseCase);
  });

  tearDown(() {
    paymentsBloc.close();
  });

  final mockTransactionFilter1 = ConcreteFilterEntity(
    key: 'filter1',
    label: 'Filter 1',
    isDefault: true,
  );

  final mockTransactionFilter2 = ConcreteFilterEntity(
    key: 'filter2',
    label: 'Filter 2',
    isDefault: false,
  );

  final mockTransaction1 = ConcretePaymentsTransactionsEntity(
    key: 'txn1',
    paymentType: 'filter1',
    processDate: DateTime(2023, 1, 1),
    actualPaymentAmount: 100.0,
    actualPrincipalPaymentAmount: 80.0,
    actualFee: 5.0,
    actualInterestPaymentAmount: 15.0,
    outstandingPrincipalBalance: 900.0,
    outstandingLoanBalance: 1000.0,
    actualPaymentPostDate: DateTime(2023, 1, 2),
  );

  final mockTransaction2 = ConcretePaymentsTransactionsEntity(
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

  final mockPaymentsInfo = ConcretePaymentsInfoEntity(
    paymentsScheduled: [],
    summary: [],
    transactionFilter: [mockTransactionFilter1, mockTransactionFilter2],
    transactions: [mockTransaction1, mockTransaction2],
  );

  final defaultFilterKeys = [mockTransactionFilter1.key];

  group('PaymentsBloc', () {
    test('estado inicial deve ter PaymentsTab.payments selecionada', () {
      expect(paymentsBloc.state.selectedTab, equals(PaymentsTab.payments));
      expect(paymentsBloc.state.status, equals(PaymentsStatus.initial));
      expect(paymentsBloc.state.paymentsInfo, isNull);
      expect(paymentsBloc.state.errorMessage, isNull);
      expect(paymentsBloc.state.activeTransactionFilterKeys, isEmpty);
      expect(paymentsBloc.state.transactionFilter, isEmpty);
    });

    blocTest<PaymentsBloc, PaymentsState>(
      'emite [PaymentsState com tab atualizada] quando PaymentsTabChanged é adicionado',
      build: () => paymentsBloc,
      act:
          (bloc) =>
              bloc.add(const PaymentsTabChanged(PaymentsTab.transactions)),
      expect:
          () => [
            paymentsBloc.state.copyWith(selectedTab: PaymentsTab.transactions),
          ],
    );
blocTest<PaymentsBloc, PaymentsState>(
  'emite [loading, error] quando LoadPaymentsEvent é adicionado e o caso de uso falha',
  build: () {
    when(mockGetPaymentsUseCase.call()).thenAnswer(
      (_) async => Left(GenericFailure(message: AppConstants.genericError001)),
    );
    return paymentsBloc;
  },
  act: (bloc) => bloc.add(LoadPaymentsEvent()),
  expect: () => [
    const PaymentsState(
      selectedTab: PaymentsTab.payments,
      status: PaymentsStatus.loading,
      errorMessage: null, 
    ),
    PaymentsState(
      selectedTab: PaymentsTab.payments,
      status: PaymentsStatus.error,
      errorMessage: AppConstants.genericError001,
    ),
  ],
  verify: (_) {
    verify(mockGetPaymentsUseCase.call()).called(1);
  },
);


    blocTest<PaymentsBloc, PaymentsState>(
      'emite novo estado com chaves de filtro atualizadas quando UpdateTransactionFilterKeys é adicionado',
      build: () => paymentsBloc,
      act:
          (bloc) => bloc.add(
            const UpdateTransactionFilterKeys(['filter1', 'filter2']),
          ),
      expect:
          () => [
            paymentsBloc.state.copyWith(
              activeTransactionFilterKeys: ['filter1', 'filter2'],
            ),
          ],
    );

    group('getFilteredTransactions', () {
      test(
        'retorna transações filtradas com base nas chaves de filtro ativas',
        () {
          final testState = paymentsBloc.state.copyWith(
            selectedTab: PaymentsTab.transactions,
            status: PaymentsStatus.loaded,
            paymentsInfo: mockPaymentsInfo,
            activeTransactionFilterKeys: ['filter1'],
          );

          paymentsBloc.emit(testState);

          final filteredTransactions = paymentsBloc.getFilteredTransactions();

          expect(filteredTransactions.length, equals(1));
          expect(filteredTransactions[0], equals(mockTransaction1));
        },
      );

      test('retorna lista vazia quando paymentsInfo é null', () {
        final filteredTransactions = paymentsBloc.getFilteredTransactions();
        expect(filteredTransactions, isEmpty);
      });
    });
  });
}
