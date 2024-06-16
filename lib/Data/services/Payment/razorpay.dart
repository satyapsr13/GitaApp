// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Presentation/Screens/Payments/payment_success_screen.dart';
import '../../../Presentation/Widgets/Dialogue/dialogue.dart';
import '../../../Utility/next_screen.dart';

class RazorPayIntegration {
  final Razorpay _razorpay = Razorpay();
  final BuildContext context;
  RazorPayIntegration(this.context);
  String orderIId = "";
// keysecret bMtlhnhHL0eFCsHWPU1DrgOU
// keyId rzp_test_XliX0MkS1dYFJT
  final razorPayKey =
      kDebugMode ? "rzp_test_B49TJKd6efoaqX" : "rzp_live_6Q8GhuW4PxvW1u";
  final razorPaySecret =
      kDebugMode ? "76ixsyR5u1USQJxZDT1grZzu" : "I88xIMKKFbPBYHTYSFtNWAqO";
  intiateRazorPay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    BlocProvider.of<UserCubit>(context).sendPremiumPurchaseToBackend(
        orderId: response.orderId.toString(),
        paymentId: response.paymentId.toString(),
        signature: response.signature.toString(),
        isSuccess: true);
    nextScreenReplace(context, const PaymentSuccessScreen());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Logger().e(response.message);
    // showSupportDialogue(
    //     showSpecilOfferImage: false,
    //     isGreenGradientButton: true,
    //     context: context,
    //     title: tr("join_wgruoup"),
    //     buttonText: tr("join_support_group"),
    //     image: "https://manage.connectup.in/rishteyy/occasions/joinwa.jpg",
    //     mq: const Size(350, 350),
    //     onTap: (() async {
    //       try {
    //         String url = "https://connectup.in/rishteyy/support";
    //         if (await canLaunchUrl(Uri.parse(url))) {
    //           await launchUrl(Uri.parse(url),
    //               mode: LaunchMode.externalApplication);
    //         }
    //       } catch (e) {}
    //     }));
    BlocProvider.of<UserCubit>(context).sendPremiumPurchaseToBackend(
        orderId: orderIId,
        isSuccess: false,
        error: "${response.code}__#__${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  openSesstion(
      {required num amount,
      required int planId,
      required BuildContext context}) {
    final userState = BlocProvider.of<UserCubit>(context, listen: false).state;
    final number = userState.userNumber;
    final name = userState.userName;
    final userId = userState.userId;
    amount = amount * 100;
    razorPayApi(amount,
            recieptId: "${userId}_${DateTime.now().millisecondsSinceEpoch}")
        .then((value) {
      orderIId = value.toString();
      var options = {
        'key': razorPayKey,
        'amount': amount,
        'name': 'Rishteyy',
        'theme': {'color': '#FFA500'},
        'order_id': value,
        'image': 'https://rishteyy.in/assets/guest/img/logo.png',
        'description':
            'PlanId :- ${planId} subscribe by \n Name:- ${name},\n Number:-${number} @ ${DateTime.now()}',
        'timeout': 600,
        'prefill': {
          "name": name,
          'contact': number,
          // 'email': 'rishteyyapp@gmail.com',
        },
        'notes': {
          "plan_id": planId,
          'user_id': userId,
          "name": name,
          "number": number,
          'description':
              'PlanId :- ${planId} subscribe by \n Name:- ${name},\n Number:-${number} @ ${DateTime.now()}',
        },
      };
      _razorpay.open(options);
    });
  }

  Future<String> razorPayApi(num amount,
      {String recieptId = "rcp_id_1"}) async {
    Dio dio = Dio();
    var auth =
        'Basic ${base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['Authorization'] = auth;

    try {
      final res = await dio.post(
        "https://api.razorpay.com/v1/orders",
        data: json.encode({
          "amount": amount, // Amount in smallest unit like in paise for INR
          "currency": "INR", //Currency
          "receipt": recieptId //Reciept Id
        }),
      );
      return res.data["id"];
    } catch (e) {
      return "";
    }
  }
}
