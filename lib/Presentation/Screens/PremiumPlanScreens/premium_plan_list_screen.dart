import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Data/model/api/Premium/subscribe_plan_list_response.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/model_bottom_sheet.dart';
import 'premium_plan_screen.dart';

class PremiumPlanListScreen extends StatefulWidget {
  const PremiumPlanListScreen({super.key});

  @override
  State<PremiumPlanListScreen> createState() => _PremiumPlanListScreenState();
}

class _PremiumPlanListScreenState extends State<PremiumPlanListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<UserCubit>(context).fetchSubscribePlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Premium Plan Info',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state.subscriptionPlansStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.subscriptionPlansStatus == Status.failure) {
            return Center(
              child: TextButton.icon(
                onPressed: () {
                  BlocProvider.of<UserCubit>(context).fetchSubscribePlans();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(
                            // height: 15,
                            width: mq.width * 0.9,
                            height: mq.width * 0.4,
                            child: Image.asset(
                              "assets/images/plans_list_topimg.jpg",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Premium plan\n subscription is valid till",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                                BlocProvider.of<UserCubit>(context)
                                            .state
                                            .varifiedTill ==
                                        null
                                    ? SizedBox()
                                    : Text(
                                        DateFormat("yMMMd").format(
                                            BlocProvider.of<UserCubit>(context)
                                                .state
                                                .varifiedTill!),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Subscription History',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey, thickness: 1),
                  ...List.generate(state.listOfSubscribePlans.length, (index) {
                    final SubscribePlanList e = state.listOfSubscribePlans[
                        state.listOfSubscribePlans.length - index - 1];
                    final bool isSuccess = (e.status == "success");
                    return Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            showCBottomSheet(
                              context: context,
                              height: 330,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Opacity(
                                          opacity: 0,
                                          child: Text(
                                            DateFormat("yMMMd", getLocale())
                                                .format(e.createdAt!),
                                            textScaleFactor: 1,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          (tr("_a_") == "A"
                                                  ? e.plan?.duration
                                                  : e.plan?.durationHindi) ??
                                              "",
                                          textScaleFactor: 1,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("yMMMd", getLocale())
                                              .format(e.createdAt!),
                                          textScaleFactor: 1,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Order Id:-',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        SelectableText(
                                          '${e.orderId}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: e.orderId));
                                              toast("Order Id Copied");
                                            },
                                            icon: const Icon(
                                              Icons.copy,
                                              color: Colors.black,
                                              size: 15,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Visibility(
                                      visible: isSuccess,
                                      child: Row(
                                        children: [
                                          const Text('Payment Id:-',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              )),
                                          const Spacer(),
                                          SelectableText(
                                            (e.paymentId ?? ""),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: e.paymentId));
                                                toast("Payment Id Copied");
                                              },
                                              icon: const Icon(
                                                Icons.copy,
                                                color: Colors.black,
                                                size: 15,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Visibility(
                                      visible: e.jsonResponse?.vpa != null,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Method:- ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          SelectableText(
                                            ("${e.jsonResponse?.vpa ?? ""}"),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 1,
                                            child: IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: e.jsonResponse
                                                                  ?.vpa ??
                                                              ""));
                                                  toast("Copied");
                                                },
                                                icon: const Icon(
                                                  Icons.copy,
                                                  color: Colors.black,
                                                  size: 15,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            nextScreenWithFadeAnimation(context,
                                                const PremiumPlanScreen());
                                          },
                                          style: const ButtonStyle(
                                              // backgroundColor: AppColors.primaryColor
                                              ),
                                          child: Text(
                                            isSuccess ? 'Renew' : "Retry",
                                            style: const TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹${e.amount} ',
                                          style: TextStyle(
                                            color: isSuccess
                                                ? Colors.green
                                                : Colors.grey,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          child: ListTile(
                            // leading: const Icon(Icons.add),
                            title: Text(
                              (tr("_a_") == "A"
                                      ? e.plan?.duration
                                      : e.plan?.durationHindi) ??
                                  "",
                              textScaleFactor: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              '₹${e.amount}',
                              style: TextStyle(
                                color: isSuccess ? Colors.green : Colors.grey,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat("yMMMd", getLocale())
                                  .format(e.createdAt!),
                              textScaleFactor: 1,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            selected: true,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          );
        }));
  }
}
