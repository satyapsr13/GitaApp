import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rishteyy/Presentation/Widgets/snackbar.dart';

import 'package:sms_autofill/sms_autofill.dart';

import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/enums.dart';
import '../../Constants/locations.dart';
import '../../Data/model/ObjectModels/user.model.dart';
import '../../Data/services/secure_storage.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Widgets/Buttons/gradient_primary_button.dart';
import '../Widgets/Buttons/switch_button.dart';
import 'PostsScreens/post_setting_screen.dart';
import 'language_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SmsAutoFill _autoFill = SmsAutoFill();
// final completePhoneNumber = await _autoFill.hint;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  String alternateMobileNumber = "";
  final _formKey = GlobalKey<FormState>();
  Future<void> _showChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    tr('choose_image_source'),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          _saveImages(ImageSource.camera);
                        },
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera,
                                  color: AppColors.primaryColor,
                                  size: 50,
                                )),
                            Text(
                              tr('camera'),
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        // leading: const Icon(Icons.photo_camera),
                        // title: const Text('Camera'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          _saveImages(ImageSource.gallery);
                        },
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.primaryColor,
                                  size: 50,
                                )),
                            Text(
                              tr('gallery'),
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Uint8List? image;
  String? pickedImagePath;

  Future<Uint8List?> _saveImages(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return null;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
          uiSettings: Constants.androidCropSetting);

      if (croppedFile != null) {
        // return null;
        final directory = await getApplicationDocumentsDirectory();
        final date = DateTime.now().toUtc().toIso8601String();

        final fileName = "${directory.path}/$date.png";
        image = File(croppedFile.path).readAsBytesSync();
        await File(croppedFile.path).copy(fileName);
        pickedImagePath = fileName;
        // if (image != null) {}

        SecureStorage storage = SecureStorage();
        setState(() {});
        await storage
            .storeLocally(key: "PHOTO_URL", value: fileName)
            .then((value) {
          BlocProvider.of<UserCubit>(context).profileImagesListOperations(
              addProfile: true,
              photo: ProfilePhotos(
                  localUrl: fileName,
                  isActive: false,
                  id: BlocProvider.of<UserCubit>(context, listen: false)
                      .state
                      .getUniquePhotoId()));
        });

        return image;
      } else {}
    } catch (e) {}
    return null;
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).fetchBlockedNumbers();

    loadInitialValues();
    super.initState();
  }

  void loadInitialValues() {
    setState(() {
      firstNameController.text =
          BlocProvider.of<UserCubit>(context, listen: false).state.userName;
      occupationController.text =
          BlocProvider.of<UserCubit>(context, listen: false)
              .state
              .userOccupation;
    });
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();

    numberController.dispose();
    occupationController.dispose();
  }

  bool firstTimeTap = true;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 15,
          width: mq.width,
          child: const FittedBox(
            child: Text(
              "By proceeding, you agree to the Rishteyy's Privacy Policy and Terms & Conditions.",
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
      body: BlocConsumer<UserCubit, UserState>(listener: ((context, state) {
        if (state.status == Status.authSuccess) {
          nextScreen(context, const PostSettingScreen());
        }
        if (state.status == Status.failure) { 
          showSnackBar(context, Colors.red, state.loginError);
        }
      }), builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                GradientContainer(mq: mq),
                Column(
                  children: [
                    SizedBox(height: mq.height * 0.35 - 50),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          textFieldWidget(
                              controller: firstNameController,
                              title: tr("first_name"),
                              maxLength: 30,
                              isRequired: true),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormField(
                              controller: numberController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onTap: !firstTimeTap
                                  ? null
                                  : (() async {
                                      firstTimeTap = false;
                                      final completePhoneNumber =
                                          await _autoFill.hint;
                                      if (completePhoneNumber != null) {
                                        setState(() {
                                          String finalNumber =
                                              completePhoneNumber.toString();
                                          alternateMobileNumber = finalNumber;
                                          if (finalNumber.length > 10) {
                                            numberController.text =
                                                finalNumber.substring(
                                                    finalNumber.length - 10);
                                          } else {
                                            numberController.text =
                                                completePhoneNumber.toString();
                                          }
                                        });
                                      }
                                    }),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validator: (val) {
                                if (val.toString().length < 10) {
                                  return tr("invalid_number");
                                }
                                List<String> blockedNumbers =
                                    BlocProvider.of<UserCubit>(context)
                                        .state
                                        .listOfInvalidBlockedNumbers;
                                for (final e in blockedNumbers) {
                                  if (val.toString().startsWith(e)) {
                                    return tr("invalid_number");
                                  }
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: tr("number"),
                                prefix: const Text('+91 '),
                                labelStyle: const TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: AppColors.orangeColor, width: 2),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              const Spacer(),
                              Text(tr("show_number"),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )),
                              const SizedBox(width: 5),
                              CSwitch(onChange: (val) {
                                BlocProvider.of<PostCubit>(context)
                                    .setStateVariables(isNumberVisible: val);
                              }),
                              const SizedBox(width: 15),
                            ],
                          ),

                          textFieldWidget(
                              controller: occupationController,
                              title: tr("occupation"),
                              maxLength: 40),

                          // const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2, color: Colors.grey)),
                                child: Row(
                                  children: [
                                    image == null
                                        ? SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                AppImages.addImageIcon))
                                        : Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.memory(image!,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                    const Spacer(),
                                    SizedBox(
                                      width: mq.width * 0.5,
                                      child: Text(
                                        tr("please_upload_your_image"),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          PrimaryButtonGradient(
                            buttonText: tr('next'),
                            isLoading: state.status == Status.loading,
                            // mq: mq,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<UserCubit>(context)
                                    .loginScreenLoginButtonOperation(
                                        userName: firstNameController.text,
                                        userNumber: numberController.text,
                                        pickedImagePath: pickedImagePath,
                                        occupation: occupationController.text,
                                        alternateMobileNumber:
                                            alternateMobileNumber);
                              }
                            },
                          ),

                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      //floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }

  Padding textFieldWidget(
      {required TextEditingController controller,
      required String title,
      bool isRequired = false,
      int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        validator: (val) {
          if (isRequired == false) {
            return null;
          }
          if (val!.isEmpty) {
            return tr("field_can_not_be_empty", namedArgs: {"title": title});
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            color: AppColors.primaryColor,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green)),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: AppColors.orangeColor, width: 2),
          ),
        ),
      ),
    );
  }
}
