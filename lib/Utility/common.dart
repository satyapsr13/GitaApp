// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gita/Presentation/Screens/Chats/admin_chats_screen.dart';
import 'package:gita/Presentation/Screens/Frames/frames_list_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Constants/constants.dart';
import '../Data/services/secure_storage.dart';
import '../Presentation/Screens/OtherScreens/donate.screen.dart';
import '../Presentation/Screens/OtherScreens/rating_screen.dart';
import '../Presentation/Screens/PremiumPlanScreens/premium_plan_screen.dart';
import '../Presentation/Screens/SeriesPosts/GitsGyanScreens/gita_sloke_main_screen.dart';
import '../Presentation/Screens/profile.screen.dart';
import 'next_screen.dart';

sharePost(String path) async {
  await Share.shareFiles([path], text: getOldPromotionLink());
}

String? validateValueWithRegex(
    String? value, String fieldName, String pattern) {
  if (value != null) {
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid $fieldName";
    } else {
      return null;
    }
  } else {
    return tr('fieldCannotBeEmpty', namedArgs: {"fieldName": fieldName});
  }
}

String getRandormSticker({int? id}) {
  if (id != null) {
    return "assets/images/sticker_$id.png";
  }
  return "assets/images/sticker_${DateTime.now().second % 8}.png";
}

String? isValidPhoneNumber(String? string) {
  if (string == null || string.isEmpty) {
    return tr('fieldCannotBeEmpty', namedArgs: {"fieldName": "Phone number"});
  }

  const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return "Enter a valid phone number";
  }
  return null;
}

String? isValidOtp(String? string) {
  if (string == null || string.isEmpty) {
    return tr('fieldCannotBeEmpty', namedArgs: {"fieldName": 'OTP'});
  }

  const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return "Enter a valid OTP";
  } else if (string.length != 4) {
    return "Enter a valid OTP";
  }
  return null;
}

String? nullEmptyValidation(String? string, String fieldName) {
  if (string == null || string.isEmpty) {
    return tr('fieldCannotBeEmpty', namedArgs: {"fieldName": fieldName});
  }
  return null;
}

String? validatePhoneNumber(String? string, String fieldName) {
  RegExp phoneRegex = RegExp(r"^[0-9]");
  if (string != null) {
    if (phoneRegex.hasMatch(string)) {
      if (string.startsWith('0')) {
        return "$fieldName cannot start with 0";
      }
      if (string.length < 10) {
        return "$fieldName cannot be less than 10 digits";
      } else {
        return null;
      }
    } else {
      return "Enter valid input";
    }
  }
  return tr('fieldCannotBeEmpty', namedArgs: {"fieldName": fieldName});
}

String? emailValidation(String? string) {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (string == null || string.isEmpty) {
    return null;
  } else if (!emailRegex.hasMatch(string)) {
    return "Enter valid email";
  }
  return null;
}

String getPlainPhoneNumber(String phoneNumber) {
  return phoneNumber
      .trim()
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll('-', '');
}

String phoneNumberWithCountryCode(String phone) {
  final regex = RegExp(r"^0+(?!$)");
  String res = phone
      .trim()
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll('-', '');
  res = res.replaceAllMapped(regex, (match) {
    return '';
  });
  if (res.startsWith("+")) {
    res = res.replaceAll("+", '');
  } else if (res.startsWith("00")) {
    res = res;
  } else {
    res = "63$res";
  }
  return res;
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date.toLocal());
}

Future<Uint8List?> saveImages(ImageSource source) async {
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
      Uint8List image = File(croppedFile.path).readAsBytesSync();
      File(croppedFile.path).copy(fileName);

      // if (image != null) {}

      SecureStorage storage = SecureStorage();
      // setState(() {});
      await storage.storeLocally(key: "PHOTO_URL", value: fileName);
      // await storage.writeToLocalStorage(
      //     SecureStorage.localPhotoPathKey, fileName);

      return image;
    } else {
      return null;
      // showSnackBar(context, Colors.red, tr("please_try_again"));
    }
  } catch (e) {
    // showSnackBar(context, Colors.red, 'Error: $e');
    // print("---------------$e--------------");
  }
  return null;
}

String getPromotionLinkForTags(
    {required String userName,
    required String tag,
    required String userId,
    required String postId}) {
  String encodedUserName = (1 == 1)
      ? userName.trim().replaceAll(" ", "+")
      : Uri.encodeQueryComponent(userName);
  String webPostLink =
      "https://rishteyy.in/p/$postId/$userId?name=$encodedUserName";
  bool isValidUserIdAndPostId = false;
  if (((int.tryParse(userId) ?? 0) > 0) && ((int.tryParse(postId) ?? 0) > 0)) {
    isValidUserIdAndPostId = true;
  }

  if (isValidUserIdAndPostId == false) {
    return tr("promotion_text_old");
  }
  String promotionLink = tr('promotion_text_for_tag_screen', namedArgs: {
    "name": userName,
    "postLink": webPostLink,
    "tag": tag,
  });

  return promotionLink;
}

String getNewPromotionLink(
    {required String userName,
    required String date,
    required String userId,
    required String postId}) {
  String encodedUserName = (1 == 1)
      ? userName.trim().replaceAll(" ", "+")
      : Uri.encodeQueryComponent(userName);
  String webPostLink =
      "https://rishteyy.in/p/$postId/$userId?name=$encodedUserName";
  bool isValidUserIdAndPostId = false;
  if (((int.tryParse(userId) ?? 0) > 0) && ((int.tryParse(postId) ?? 0) > 0)) {
    isValidUserIdAndPostId = true;
  }

  if (isValidUserIdAndPostId == false) {
    return tr("promotion_text_old");
  }
  String promotionLink = tr('promotion_text', namedArgs: {
    "name": userName,
    "postLink": webPostLink,
    "date": date,
  });

  return promotionLink;
}

String getOldPromotionLink() {
  return tr("promotion_text_old");
}

Color convertJsonToColor(String jsonString) {
  try {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    String colorHex = jsonMap['color'];

    if (colorHex != null && colorHex.isNotEmpty) {
      if (colorHex.startsWith('#')) {
        colorHex = colorHex.substring(1);
      }

      return Color(int.parse(colorHex, radix: 16) + 0xFF000000);
    }
  } catch (e) {
    print('Error converting JSON to Color: $e');
  }

  return Colors.black;
}

Color hexToColor(String hexColor) {
  if (hexColor.isEmpty) {
    return Colors.white;
  }
  hexColor = hexColor.replaceAll("#", "");

  int hexValue = int.parse(hexColor, radix: 16);

  return Color(hexValue | 0xFF000000);
}

navigatorFunction(String screenName, BuildContext context) {
  screenName = screenName.toLowerCase();
  if (screenName == "gitagyanmainscreen") {
    nextScreenWithFadeAnimation(context, const GitagyanMainScreen());
  } else if (screenName == "profilescreen") {
    nextScreenWithFadeAnimation(context, const ProfileScreen());
  } else if (screenName == "ratingscreen") {
    nextScreenWithFadeAnimation(context, RatingScreen());
  } else if (screenName == "donatescreen") {
    nextScreenWithFadeAnimation(context, DonateScreen());
  } else if (screenName == "paymentscreen") {
    nextScreenWithFadeAnimation(context, const PremiumPlanScreen());
  } else if (screenName == "framescreen") {
    nextScreenWithFadeAnimation(context, const FramesListScreen());
  } else if (screenName == "chatscreen") {
    nextScreenWithFadeAnimation(context, const AdminChatScreen());
  } else {
    toast(tr("please_update_your_app"));
  }
}

void removeDuplicatesFromPathTracker(List<String> pathTracker) {
  try {
    Set<String> uniquePaths = Set<String>.from(pathTracker);

    pathTracker.clear();
    pathTracker.addAll(uniquePaths.toList());
  } catch (e) {}
}
