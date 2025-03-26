import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/src/modules/payments/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:base_project/src/modules/payments/presentation/bloc/payments_bloc/payments_state.dart';

import 'build_financial_card_component.dart';

class PaymentScheduleDashboard extends StatelessWidget {
  const PaymentScheduleDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
        // Tratamento de estados
        if (state.status == PaymentsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == PaymentsStatus.error) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        final info = state.paymentsInfo;
        if (info == null) {
          return const Center(child: Text('No payment data available.'));
        }
        final summaryList = info.summary;
        final scheduleList = info.paymentsScheduled;

        return Container(
          color: const Color(0xFFF5F5F5),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 640 ? 16 : 12,
            vertical: MediaQuery.of(context).size.width > 640 ? 20 : 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Faz a Column se ajustar aos filhos
            children: [
          

              // Payment prompt
         

              // Tab navigation


              // Payment schedule list
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem interna
                    itemCount: scheduleList.length,
                    itemBuilder: (context, index) {
                      final paymentItem = scheduleList[index];
                      // Exemplo: destaca o primeiro item como "Next"
                      final isNext = (index == 0);
                      return _buildPaymentItem(
                        date: paymentItem.paymentDateFormatted,
                        amount: paymentItem.total.toStringAsFixed(2),
                        isNext: isNext,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentItem({
    required String date,
    required String amount,
    bool isNext = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF37404E),
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
              Row(children: [
                  Text(
                  '\$',
                  style: const TextStyle(
                    color: Color(0xFF37404E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                Text(
                  'amount',
                  style: const TextStyle(
                    color: Color(0xFF37404E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
              ),
            ],
          ),
          if (isNext)
            Positioned(
              right: 30,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF232F69).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Color(0xFF232F69),
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

