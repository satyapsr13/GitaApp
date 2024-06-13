// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

// import 'package:overlay_support/overlay_support.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/enums.dart';
import '../../../Constants/locations.dart';
import '../../../Data/model/api/Premium/premium_plan_response.dart';
import '../../../Data/services/Payment/razorpay.dart';
import '../../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Buttons/gradient_primary_button.dart';
import 'premium_plan_list_screen.dart';

class PremiumPlanScreen extends StatefulWidget {
  // const PremiumPlanScreen({super.key});
  final int? preSelected;

  const PremiumPlanScreen({super.key, this.preSelected});
  @override
  State<PremiumPlanScreen> createState() => _PremiumPlanScreenState();
}

class _PremiumPlanScreenState extends State<PremiumPlanScreen> {
  late RazorPayIntegration _integration;
  @override
  void initState() {
    _integration = RazorPayIntegration(context);

    _integration.intiateRazorPay();
    BlocProvider.of<UserCubit>(context).fetchPremiumPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final bool isEnglish =
        BlocProvider.of<LocaleCubit>(context, listen: false).state.localeKey ==
            "en";
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Upgrade to Premium',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  nextScreenWithFadeAnimation(context, PremiumPlanListScreen());
                },
                icon: const Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.black,
                )),
          ],
        ),
        persistentFooterButtons: [
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    PrimaryButtonGradient(
                      onPressed: () {
                        Logger().i("e1");
                        try {
                          _integration.openSesstion(
                              amount: (state.selectedPlan?.price ?? 1000),
                              planId: state.selectedPlan?.id ?? 0,
                              context: context);
                          Logger().i("e");
                        } catch (e) {
                          Logger().i(e);
                        }
                      },
                      buttonText: tr("buy_premium"),
                      isLoading: state.paymentStatus == Status.loading,
                      // mq: mq,
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        nextScreenWithFadeAnimation(
                            context, PremiumPlanListScreen());
                      },
                      child: Text(
                        tr("see_payment_history"),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            );
          }),
        ],
        body: BlocConsumer<UserCubit, UserState>(listener: (context, state) {
         
        }, builder: (context, state) {
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

          return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: mq.width * 0.9,
                        // height: mq.width * 0.9,
                        child: CachedNetworkImage(
                          imageUrl: isEnglish
                              ? state.premiumPlan?.image ?? ""
                              : state.premiumPlan?.imageHindi ?? "",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ...List.generate(state.premiumPlan?.plans?.length ?? 0,
                        ((index) {
                      final Plan? plan = state.premiumPlan?.plans?[index];
                      final String name = plan?.name ?? "";

                      final String offer =
                          (isEnglish ? plan?.offer : plan?.offerHindi) ?? "";
                      final String duration =
                          (isEnglish ? plan?.duration : plan?.durationHindi) ??
                              "";
                      final String daily =
                          (isEnglish ? plan?.daily : plan?.dailyHindi) ?? "";
                      final int mrp =
                          (isEnglish ? plan?.mrp : plan?.mrp) ?? 1000;
                      final int price =
                          (isEnglish ? plan?.price : plan?.price) ?? 1000;
                      final bool isSelected =
                          state.selectedPlan?.id == plan?.id;
                      return plan == null
                          ? SizedBox()
                          : Column(
                              children: [
                                Stack(
                                  alignment: Alignment.topCenter,
                                  clipBehavior: Clip.none,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<UserCubit>(context)
                                            .updateStateVariables(
                                                selectedPlan: plan);
                                      },
                                      child: Container(
                                          width: mq.width * 0.9,
                                          constraints: BoxConstraints(
                                            minHeight: 100,
                                          ),
                                          decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.amber
                                                      .withOpacity(0.1)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 2,
                                                  color: isSelected
                                                      ? AppColors.primaryColor
                                                      : Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      offer,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "₹$price ",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "₹$mrp Rs",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 22,
                                                            color: isSelected
                                                                ? AppColors
                                                                    .primaryColor
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Container(
                                                  width: mq.width * 0.3,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : AppColors.primaryColor
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: Text(
                                                          daily,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: isSelected
                                                                  ? Colors.black
                                                                  : AppColors
                                                                      .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                      top: -12.5,
                                      child: Container(
                                        height: 25,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            duration,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -12.5,
                                      right: 20,
                                      child: Visibility(
                                        visible: isSelected,
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                            AppImages.nonPremiumUserIcon,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            );
                    })),
                    SizedBox(height: 150),
                    // QrImage(
                    //       data:
                    //           "https://api.razorpay.com/v1/checkout/$orderId?amount=$amount&key=$apiKey", // Use the payment URL as QR code data
                    //       version: QrVersions.auto,
                    //       size: 200.0,
                    //     ),
                  ],
                ),
              ),
            );
          });
        }));
  }
}
