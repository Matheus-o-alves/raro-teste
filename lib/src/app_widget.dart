import 'package:base_project/src/modules/payments/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:base_project/src/modules/payments/presentation/page/paymenPage/components/schedule_empty_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_svg/svg.dart';

import 'modules/payments/data/data.dart';
import 'modules/payments/domain/usecase/usecase.dart';
import 'modules/payments/infra/datasource/datasource.dart';
import 'modules/payments/presentation/bloc/payments_bloc/payments_event.dart';
import 'modules/payments/presentation/page/paymenPage/components/appBar_component.dart' show DefaultAppBar;

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF232F69))),
      home: const PaymentsTransactionsPage(),
    );
  }
}

class PaymentsTransactionsPage extends StatelessWidget {
  const PaymentsTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF232F69),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'Payments',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  'assets/question_icon.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
    body: BlocProvider(
  create: (_) => PaymentsBloc(
    GetPaymentsUseCase(
      PaymentsRepositoryImpl(PaymentsDatasourceImpl()),
    ),
  )..add(LoadPaymentsEvent()),
  child: const PaymentsPage(),
),

      ),
    );
  }
}
