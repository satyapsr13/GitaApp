// ignore_for_file:  must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart'; 
import 'package:url_launcher/url_launcher.dart';

import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Widgets/Buttons/primary_button.dart';

class RatingScreen extends StatelessWidget {
  // const RatingScreen({super.key});
  bool isEnglish = (tr("_a_") == "A");
  TextEditingController messageController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  RatingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Rate Risheyy App',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child:
              BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
            return SizedBox(
              width: mq.width,
              height: mq.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: mq.height * 0.01),
                      SizedBox(
                          height: mq.height * 0.3,
                          width: mq.width,
                          child: LottieBuilder.asset(
                            "assets/images/rating.json",
                            fit: BoxFit.fill,
                          )),
                      Text(
                        isEnglish
                            ? 'Rate Our App'
                            : "हमारी एप्लिकेशन को रेट करें",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: mq.height * 0.05),
                      Text(
                        isEnglish
                            ? 'We\'d love to hear your feedback! Please take a moment to rate our app and help us improve.'
                            : "हमें आपकी प्रतिक्रिया सुनना अच्छा लगेगा! कृपया हमारी एप्लिकेशन को रेट करने के लिए एक पल निकालें और हमें सुधारने में मदद करें।",
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "👇👇👇👇👇",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: mq.height * 0.05),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RatingBar.builder(
                            initialRating: userState.userAppRating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) async {
                              // Logger().i(rating);
                              BlocProvider.of<UserCubit>(context)
                                  .updateStateVariables(userAppRating: rating);
                              if (rating > 3.9) {
                                Uri uri = Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.aeonian.rishteyy&reviewId=0");
                                if (await canLaunchUrl(uri)) {
                                  launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                }
                              } else {
                                await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxHeight: mq.height * 0.7),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 1),
                                              Container(
                                                width: 50,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text(
                                                isEnglish
                                                    ? 'Thank You for Your Feedback'
                                                    : "आपकी प्रतिक्रिया के लिए धन्यवाद",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text(
                                                isEnglish
                                                    ? 'Your feedback is crucial for us to improve. We would love to hear more about your concerns and how we can make things better. Please feel free to share any specific issues or suggestions.'
                                                    : "आपकी प्रतिक्रिया हमें सुधार करने के लिए महत्वपूर्ण है। हमें अपनी एप्लिकेशन को बेहतर बनाने के लिए और आपके सुझावों को समझने के लिए अधिक जानकारी चाहिए। कृपया हमें आपकी चिंताओं और सुझावों के बारे में अधिक बताएं।",
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  maxLines: 5,
                                                  controller: messageController,
                                                  validator: ((value) {
                                                    if (value
                                                        .toString()
                                                        .isEmpty) {
                                                      return "Please enter some suggestions";
                                                    }
                                                    return null;
                                                  }),
                                                  decoration: InputDecoration(
                                                    hintText: isEnglish
                                                        ? "Feedback"
                                                        : "सुझावों",
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 25),
                                              PrimaryButton(
                                                  onPressed: () {
                                                    BlocProvider.of<UserCubit>(
                                                            context)
                                                        .sendRatingFeedback(
                                                            message:
                                                                messageController
                                                                    .text,
                                                                    reason:"rating"
                                                                    );
                                                    Navigator.pop(context);
                                                    toast(tr(
                                                        "thanks_for_feedback"));
                                                  },
                                                  buttonText: "Submit")
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }
}
