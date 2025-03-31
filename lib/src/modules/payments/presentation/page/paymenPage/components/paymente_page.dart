// PaymentsPage.dart
import 'package:base_project/src/modules/payments/domain/entity/payments_summary_entity.dart';
import 'package:base_project/src/modules/payments/presentation/page/paymenPage/components/shimmer/shimmet_transactions_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_style.dart' show AppColors, AppTextStyles;
import '../../../bloc/payments_bloc/payments_bloc.dart';
import '../../../bloc/payments_bloc/payments_event.dart';
import '../../../bloc/payments_bloc/payments_state.dart';

import 'build_financial_card_component.dart';
import 'make_payment_component.dart';
import 'payment_scheduled_list_component.dart';
import 'schedule_page.dart/transactions_list_component.dart';
import 'shimmer/paymente_scheduled_shimmer_component.dart';
import 'shimmer/shimmer_schedule_component.dart';
import 'transaction_filter_bottom_sheet.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.background,
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
                        state.selectedTab == PaymentsTab.payments;

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
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (_, __) => const ShimmerFinancialCardComponent(),
                            ),
                          ),
                          const SizedBox(height: 16),
                       state.selectedTab==PaymentsTab.payments?  ShimmerScheduleComponent() : TransactionDetailCardShimmer(),
                        ],
                      );
                    }

                    final info = state.paymentsInfo;

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
                                child: TransactionDetailCard(
                                  transaction: transaction,
                                ),
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
      margin: const EdgeInsets.only(top: 16, bottom: 20),
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
                const PaymentsTabChanged(PaymentsTab.payments),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isPayments ? AppColors.greenAccent : AppColors.greyLine,
                    width: isPayments ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                'SCHEDULE',
                textAlign: TextAlign.center,
                style: isPayments ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected,
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
                    color: !isPayments ? AppColors.greenAccent : AppColors.greyLine,
                    width: !isPayments ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                'TRANSACTIONS',
                textAlign: TextAlign.center,
                style: !isPayments ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.softGrey.withOpacity(0.75),
          ),
          onPressed: () {
            final state = context.read<PaymentsBloc>().state;
            showTransactionFilterBottomSheet(
              context,
              state.paymentsInfo?.transactionFilter ?? [],
              state.activeTransactionFilterKeys,
            );
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
        style: AppTextStyles.messageText,
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
        style: AppTextStyles.messageText,
      ),
    );
  }
}