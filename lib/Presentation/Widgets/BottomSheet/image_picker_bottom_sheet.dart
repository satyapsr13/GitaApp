// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Data/model/ObjectModels/user.model.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart'; 

class ImagePickerModalBottomSheet extends StatelessWidget {
  final void Function()? onGallaryTap;
  final void Function()? onCameraTap;
  final String? whereToSave;
  ImagePickerModalBottomSheet({
    Key? key,
    this.onGallaryTap,
    this.onCameraTap,
    this.whereToSave = "",
  }) : super(key: key);
  String? finalPickedImage;
  Future<void> _saveImages(ImageSource source, BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
          uiSettings: Constants.androidCropSetting);

      if (croppedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final date = DateTime.now().toUtc().toIso8601String();

        final fileName = "${directory.path}/$date.png";
        File(croppedFile.path).readAsBytesSync();

        final img = File(croppedFile.path).copy(fileName);
        if (whereToSave == "UserCustomSticker") {
          finalPickedImage = fileName;
          BlocProvider.of<StickerCubit>(context).userStickerOperations(
              imageUrl: fileName,
              userId:
                  BlocProvider.of<UserCubit>(context).state.userId.toString());
          Navigator.pop(context);
        } else {
          BlocProvider.of<UserCubit>(context)
              .profileImagesListOperations(
                  addProfile: true,
                  photo: ProfilePhotos(
                      localUrl: fileName,
                      isActive: false,
                      id: BlocProvider.of<UserCubit>(context, listen: false)
                          .state
                          .getUniquePhotoId()))
              .then((value) {
            Navigator.pop(context);
          });
        }

        // newImageLocalPath = fileName;
        // SecureStorage storage = SecureStorage();
        // setState(() {});
        // await storage.writeToLocalStorage("PHOTO_URL", fileName).then((value) =>
        //     showSnackBar(context, Colors.green, tr("saved_successfully")));
      } else {
        // showSnackBar(context, Colors.red, tr("please_try_again"));
      }
    } catch (e) {
      // showSnackBar(context, Colors.red, 'Error: $e');
      // print("----showSnackBar---------$e----------------");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    _saveImages(ImageSource.camera, context);
                    // Navigator.pop(context);
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
                  onTap: () {
                    // Navigator.pop(context);
                    _saveImages(ImageSource.gallery, context);
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
  }
}
