// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/enums.dart';
import '../../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<UserCubit>(context).fetchPremiumPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        BlocProvider.of<LocaleCubit>(context, listen: false).state.localeKey ==
            "en";
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state.premiumPlanStatus == Status.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.premiumPlanStatus == Status.failure) {
            BlocProvider.of<UserCubit>(context)
                .sendRatingFeedback(message: 'error when fetching /plan api');
            return Center(
                child: TextButton.icon(
              onPressed: (() {
                BlocProvider.of<UserCubit>(context).fetchPremiumPlan();
              }),
              icon: Icon(Icons.refresh),
              label: Text(
                'Reload',
                style: const TextStyle(),
              ),
            ));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  isEnglish
                      ? state.premiumPlan?.image ?? ""
                      : state.premiumPlan?.imageHindi ?? "",
                )
              ],
            ),
          );
        }));
  }
}
