import 'package:base_project/src/modules/payments/domain/entity/payments_summary_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/payments_bloc/payments_bloc.dart';
import '../../bloc/payments_bloc/payments_event.dart';
import '../../bloc/payments_bloc/payments_state.dart';
import 'build_financial_card_component.dart';
import 'make_payment_component.dart';
import 'payment_scheduled_list_component.dart';
import 'schedule_page.dart/transactions_list_component.dart';
import 'shimmer/paymente_scheduled_shimmer_component.dart';
import 'shimmer/shimmer_schedule_component.dart';
import 'transaction_filter_bottom_sheet.dart'; // Componente PaymentScheduleDashboard

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: const Color(0xFFF4F5F6),
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, state) {
                    final isPayments =
                        state.selectedTab == PaymentsTab.Payments;

                    // ⛔️ Enquanto estiver carregando, não acessa nada do state.paymentsInfo
                    if (state.status == PaymentsStatus.loading) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          _buildTabNavigation(context, isPayments),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 8),
                              itemBuilder:
                                  (_, __) =>
                                      const ShimmerFinancialCardComponent(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ShimmerScheduleComponent(),
                        ],
                      );
                    }

                    // ✅ Agora é seguro acessar o state
                    final info = state.paymentsInfo;

                    // Segurança adicional caso paymentsInfo ainda seja null (evita crash raro)
                    if (info == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final scheduledList = info.paymentsScheduled;
                    final isScheduledEmpty =
                        scheduledList == null || scheduledList.isEmpty;
                    final summaryList = info.summary;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        if (isPayments) ...[
                          if (isScheduledEmpty) ...[
                            _buildTabNavigation(context, isPayments),
                            _buildEmptyScheduleMessage(),
                          ] else ...[
                            financialCardWidget(summaryList),
                            MakePaymentComponent(),
                            _buildTabNavigation(context, isPayments),
                            PaymentScheduleDashboard(),
                          ],
                        ] else ...[
                          if (info.transactions.isNotEmpty) ...[
                            financialCardWidget(summaryList),

                            MakePaymentComponent(),
                            _buildTabNavigation(context, isPayments),
                            ...info.transactions.map(
                              (transaction) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: 
                                TransactionDetailCard(transaction: transaction)
                               
                              ),
                            ),
                          ] else ...[
                            _buildTransactionsMessage(),
                          ],
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container financialCardWidget(List<PaymentsSummaryEntity> summaryList) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: summaryList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = summaryList[index];
          return BuildFinancialCardComponent(
            title: item.label,
            amount: item.value.toStringAsFixed(2),
          );
        },
      ),
    );
  }

  Widget _buildTabNavigation(BuildContext context, bool isPayments) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<PaymentsBloc>().add(
                const PaymentsTabChanged(PaymentsTab.Payments),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isPayments
                            ? const Color(0xFF54B73B)
                            : const Color(0x80DEE0E3),
                    width: isPayments ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                'SCHEDULE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color:
                      isPayments
                          ? const Color(0xFF37404E)
                          : const Color(0xFF5E646E),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.28,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<PaymentsBloc>().add(
                const PaymentsTabChanged(PaymentsTab.transactions),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        !isPayments
                            ? const Color(0xFF54B73B)
                            : const Color(0x80DEE0E3),
                    width: !isPayments ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                'TRANSACTIONS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color:
                      !isPayments
                          ? const Color(0xFF37404E)
                          : const Color(0xFF5E646E),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.28,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: const Color(0xFF868C98).withOpacity(0.75),
          ),
          onPressed: () {
            final state = context.read<PaymentsBloc>().state;
            showTransactionFilterBottomSheet(context, state.visibleOptions);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyScheduleMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(32),
      child: const Text(
        'Once your loan is booked your payment schedule will appear here. This process may take 1-2 business days.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: Color(0xFF868C98),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.43,
        ),
      ),
    );
  }

  Widget _buildTransactionsMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(32),
      child: const Text(
        'Here you will see your latest transaction history and payment activities.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: Color(0xFF868C98),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          height: 1.43,
        ),
      ),
    );
  }
}
