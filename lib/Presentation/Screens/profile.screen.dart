// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart'; 
// import 'package:sms_autofill/sms_autofill.dart';

import '../../Constants/colors.dart';
import '../../Constants/enums.dart';
import '../../Constants/locations.dart';
import '../../Data/services/secure_storage.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Widgets/Buttons/gradient_primary_button.dart';
import '../Widgets/frames_list_widget.dart';
import '../Widgets/multiple_profile_photo_widget.dart';
import 'Frames/frames_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? image;
  Uint8List? newImage;
  String? newImageLocalPath;

  Future<void> _showCamersChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        // circular shape
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
                          // setState(() {});
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

  _saveImages(ImageSource source, {String? imagePathDate}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return null;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
          uiSettings: androidCropSetting);

      if (croppedFile != null) {
        // return null;
        final directory = await getApplicationDocumentsDirectory();
        final date = imagePathDate ?? DateTime.now().toUtc().toIso8601String();

        final fileName = "${directory.path}/$date.png";
        newImage = File(croppedFile.path).readAsBytesSync();

        final img = File(croppedFile.path).copy(fileName);
        newImageLocalPath = fileName;
        SecureStorage storage = SecureStorage();
        // setState(() {});
        await storage
            .storeLocally(key: "PHOTO_URL", value: fileName)
            .then((value) {
          BlocProvider.of<UserCubit>(context)
              .loadImageAndName(isAddPhoto: true);
        });
      } else {
        // showSnackBar(context, Colors.red, tr("please_try_again"));
      }
    } catch (e) {
      // showSnackBar(context, Colors.red, 'Error: $e');
    }
  }

  Future<void> loadName() async {
    final userCubit = BlocProvider.of<UserCubit>(context, listen: false);
    _userNameController.text = userCubit.state.userName;
    _occupationController.text = userCubit.state.userOccupation;
    _phoneNumberController.text = userCubit.state.userNumber;
    setState(() {});
  }

  List<PlatformUiSettings> get androidCropSetting {
    return [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.white,
        toolbarWidgetColor: AppColors.primaryColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
        showCropGrid: true,
      ),
    ];
  }

  Future<void> clearSecureScreen() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {}
  }

  Future<void> secureScreen() async {
    try {
      if (BlocProvider.of<UserCubit>(context).state.isPremiumUser == false) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    clearSecureScreen();
    BlocProvider.of<UserCubit>(context).fetchBlockedNumbers();
    loadName();

    super.initState();
  }

  bool firstTimeTap = true;
  @override
  void dispose() {
    secureScreen();
    super.dispose();
    _userNameController.dispose();
    _occupationController.dispose();
    _phoneNumberController.dispose();
  }

  // final SmsAutoFill _autoFill = SmsAutoFill();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        // splashColor: Colors.transparent,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: BlocConsumer<UserCubit, UserState>(listener: ((context, state) {
        if (state.userProfileStatus == Status.updateSuccess) {
          toast("Profile updated successfully!");
          Navigator.pop(context);
        }
      }), builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: mq.width,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -25,
                        // right: mq.width * 0.37,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: state.fileImagePath.isEmpty
                                  ? Image.asset(AppImages.addImageIcon,
                                      fit: BoxFit.cover)
                                  : Image.file(File(state.fileImagePath),
                                      fit: BoxFit.cover)),
                        )),
                  ],
                ),

                const SizedBox(height: 35),
                MultiplePhotoSelector(mq: mq, radius: 50),
                // const SizedBox(height: 5),
                const Divider(
                  color: Color(0x55BDBDBD),
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        tr("user_info"),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: TextFormField(
                    controller: _userNameController,
                    maxLength: 30,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return tr("field_can_not_be_empty",
                            namedArgs: {"title": tr("first_name")});
                      }
                      if (val.toString().isEmpty) {
                        return tr("field_can_not_be_empty",
                            namedArgs: {"title": tr("first_name")});
                      }
                      return null;
                    },
                    decoration:
                        firstNameInputDecoration(title: tr("first_name")),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    onTap: firstTimeTap == true
                        ? null
                        : (() async {
                            // Logger().i("message");
                            // firstTimeTap = false;
                            // final completePhoneNumber = await _autoFill.hint;
                            // Logger().i("message0  $completePhoneNumber");
                            // if (completePhoneNumber != null) {
                            //   Logger().i("message1");
                            //   setState(() {
                            //     String finalNumber =
                            //         completePhoneNumber.toString();
                            //     Logger().i("message2 ");
                            //     if (finalNumber.length > 10) {
                            //       _phoneNumberController.text = finalNumber
                            //           .substring(finalNumber.length - 10);
                            //     } else {
                            //       _phoneNumberController.text =
                            //           completePhoneNumber.toString();
                            //     }
                            //     Logger().i("message2 $completePhoneNumber");
                            //   });
                            // }
                          }),
                    validator: (val) {
                      if (val.toString().length < 10) {
                        return tr("invalid_number");
                      }
                      List<String> blockedNumbers =
                          BlocProvider.of<UserCubit>(context, listen: false)
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
                      prefix: const Text(
                        '+91 ',
                      ),
                      labelText: tr("number"),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: AppColors.orangeColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: TextFormField(
                    controller: _occupationController,
                    maxLength: 40,
                    decoration:
                        firstNameInputDecoration(title: tr("occupation")),
                  ),
                ),
                const Divider(
                  color: Color(0x55BDBDBD),
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        tr("your_selected_frames"),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          nextScreenWithFadeAnimation(
                              context, const FramesListScreen());
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            Icon(
                              Icons.edit_rounded,
                              size: 15,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: FramesListWidget(
                    mq: mq,
                    showSelectedFrames: true,
                  ),
                ),
                const Divider(
                  color: Color(0x55BDBDBD),
                  thickness: 1,
                ),
                const SizedBox(height: 15),

                // Visibility(
                //   visible: kDebugMode,
                //   child: Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: TextFormField(
                //       controller: _occupationController,
                //       validator: (val) {
                //         if (val!.isEmpty) {
                //           return tr("field_can_not_be_empty");
                //         }
                //         if (val.toString().isEmpty) {
                //           return tr("field_can_not_be_empty");
                //         }
                //         return null;
                //       },
                //       decoration:
                //           firstNameInputDecoration(title: tr("occupation")),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),
                PrimaryButtonGradient(
                  buttonText: tr('save'),
                  isLoading: state.userProfileStatus == Status.loading,
                  // mq: mq,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<UserCubit>(context)
                          .profileScreenUpdateButtonOperation(
                              userName: _userNameController.text,
                              userNumber: _phoneNumberController.text,
                              occupation: _occupationController.text);
                    }
                  },
                ),

                const SizedBox(height: 30),

                // profile page in flutter
              ],
            ),
          ),
        );
      }),
      //floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }

  InputDecoration lastNameInputDecoration() {
    return InputDecoration(
      labelText: tr("last_name"),
      border:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.orangeColor, width: 2),
      ),
    );
  }

  InputDecoration firstNameInputDecoration({required String title}) {
    return InputDecoration(
      labelText: title,
      border:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.orangeColor, width: 2),
      ),
    );
  }
}
