import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/presentation/page/presentation.dart';
import 'package:flutter_test/flutter_test.dart';

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
    required String value,  
    required super.isDefault,
  }) : super(
         label: value,
       );
}



void main() {
  group('PaymentsState', () {
    final mockFilter1 = ConcreteFilterEntity(
      key: 'filter1',
      value: 'Filter 1', 
      isDefault: true,
    );
    
    final mockFilter2 = ConcreteFilterEntity(
      key: 'filter2',
      value: 'Filter 2', 
      isDefault: false,
    );
    
    final mockPaymentsInfo = ConcretePaymentsInfoEntity(
      paymentsScheduled: [],  
      summary: [],  
      transactions: [],  
      transactionFilter: [mockFilter1, mockFilter2],
    );


    test('suporta comparação de valores', () {
      expect(
        const PaymentsState(selectedTab: PaymentsTab.payments),
        const PaymentsState(selectedTab: PaymentsTab.payments),
      );
      
      expect(
        const PaymentsState(
          selectedTab: PaymentsTab.payments,
          status: PaymentsStatus.loaded,
        ),
        isNot(equals(const PaymentsState(selectedTab: PaymentsTab.payments))),
      );
    });

    test('copyWith retorna o mesmo objeto quando nenhum parâmetro é passado', () {
      const state = PaymentsState(selectedTab: PaymentsTab.payments);
      final newState = state.copyWith();
      
      expect(newState, equals(state));
    });

    test('copyWith retorna um novo objeto com os valores atualizados', () {
      const initialState = PaymentsState(
        selectedTab: PaymentsTab.payments,
        status: PaymentsStatus.initial,
      );
      
      final updatedState = initialState.copyWith(
        selectedTab: PaymentsTab.transactions,
        status: PaymentsStatus.loading,
      );
      
      expect(updatedState.selectedTab, equals(PaymentsTab.transactions));
      expect(updatedState.status, equals(PaymentsStatus.loading));
      expect(updatedState.paymentsInfo, equals(initialState.paymentsInfo));
      expect(updatedState.errorMessage, equals(initialState.errorMessage));
    });

    test('props contém todos os campos necessários para comparação', () {
      const state = PaymentsState(
        selectedTab: PaymentsTab.payments,
        status: PaymentsStatus.loaded,
        errorMessage: 'Erro',
        activeTransactionFilterKeys: ['filter1'],
      );
      
      expect(state.props, [
        PaymentsTab.payments,
        PaymentsStatus.loaded,
        null, 
        'Erro',
        ['filter1'],
        const [], 
      ]);
    });

    test('copyWith mantém valores inalterados quando não especificados', () {
      final initialState = PaymentsState(
        selectedTab: PaymentsTab.payments,
        status: PaymentsStatus.loaded,
        paymentsInfo: mockPaymentsInfo,
        errorMessage: 'Erro inicial',
        activeTransactionFilterKeys: const ['filter1'],
        transactionFilter: [mockFilter1, mockFilter2],
      );
      
      final newState = initialState.copyWith(
        status: PaymentsStatus.error,
        errorMessage: 'Novo erro',
      );
      
      expect(newState.selectedTab, equals(initialState.selectedTab));
      expect(newState.status, equals(PaymentsStatus.error));
      expect(newState.paymentsInfo, equals(initialState.paymentsInfo));
      expect(newState.errorMessage, equals('Novo erro'));
      expect(newState.activeTransactionFilterKeys, equals(initialState.activeTransactionFilterKeys));
      expect(newState.transactionFilter, equals(initialState.transactionFilter));
    });
  });
}