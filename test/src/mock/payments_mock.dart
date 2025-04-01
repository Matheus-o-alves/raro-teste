// import 'package:base_project/src/modules/payments/domain/domain.dart';

// class PaymentsMocks {
//   static PaymentsTransactionFilterEntity createMockFilter({
//     required String key,
//     required String value,
//     bool isDefault = false,
//   }) {
//     return PaymentsTransactionFilterEntity(
//       key: key,
//       label: value,
//       isDefault: isDefault,
//     );
//   }

//   static PaymentsTransactionsEntity createMockTransaction({
//     required String paymentType,
//     DateTime? processDate,
//     double actualPaymentAmount = 0.0,
//     double actualPrincipalPaymentAmount = 0.0,
//     double actualFee = 0.0,
//     double actualInterestPaymentAmount = 0.0,
//     double outstandingPrincipalBalance = 0.0,
//     DateTime? actualPaymentPostDate,
//   }) {
//     return PaymentsTransactionsEntity(
//       paymentType: paymentType,
//       processDate: processDate ?? DateTime(2023, 1, 1),
//       actualPaymentAmount: actualPaymentAmount,
//       actualPrincipalPaymentAmount: actualPrincipalPaymentAmount,
//       actualFee: actualFee,
//       actualInterestPaymentAmount: actualInterestPaymentAmount,
//       outstandingPrincipalBalance: outstandingPrincipalBalance,
//       actualPaymentPostDate: actualPaymentPostDate ?? DateTime(2023, 1, 2),
//     );
//   }

//   // static PaymentsInfoEntity createMockPaymentsInfo({
//   //   List<PaymentsTransactionsEntity>? transactions,
//   //   List<PaymentsTransactionFilterEntity>? transactionFilter,
//   // }) {
//   //   return PaymentsInfoEntity(
//   //     transactions: transactions ?? [],
//   //     transactionFilter: transactionFilter ?? [],
//   //   );
//   // }

//   static TestData createTestData() {
//     final filter1 = createMockFilter(
//       key: 'filter1',
//       value: 'Filter 1',
//       isDefault: true,
//     );
    
//     final filter2 = createMockFilter(
//       key: 'filter2',
//       value: 'Filter 2',
//       isDefault: false,
//     );
    
//     final transaction1 = createMockTransaction(
//       paymentType: 'filter1',
//       actualPaymentAmount: 100.0,
//       actualPrincipalPaymentAmount: 80.0,
//     );
    
//     final transaction2 = createMockTransaction(
//       paymentType: 'filter2',
//       actualPaymentAmount: 200.0,
//       actualPrincipalPaymentAmount: 160.0,
//     );
    
//     final paymentsInfo = createMockPaymentsInfo(
//       transactions: [transaction1, transaction2],
//       transactionFilter: [filter1, filter2],
//     );
    
//     return TestData(
//       filters: [filter1, filter2],
//       transactions: [transaction1, transaction2],
//       paymentsInfo: paymentsInfo,
//     );
//   }
// }

// /// Classe para agrupar os dados de teste
// class TestData {
//   final List<PaymentsTransactionFilterEntity> filters;
//   final List<PaymentsTransactionsEntity> transactions;
//   final PaymentsInfoEntity paymentsInfo;
  
//   TestData({
//     required this.filters,
//     required this.transactions,
//     required this.paymentsInfo,
//   });
// }