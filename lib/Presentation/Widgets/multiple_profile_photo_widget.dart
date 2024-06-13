import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Constants/colors.dart';
import '../../Constants/locations.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import 'BottomSheet/image_picker_bottom_sheet.dart';

class MultiplePhotoSelector extends StatelessWidget {
  const MultiplePhotoSelector({
    Key? key,
    required this.mq,
    this.radius,
    this.title,
    this.onSelect,
    this.isEnableScrolling = true,
  }) : super(key: key);

  final Size mq;
  final double? radius;
  final String? title;
  final bool isEnableScrolling;
  final void Function(String)? onSelect;
  @override
  Widget build(BuildContext context) {
    double? outerRadius;
    if (radius != null) {
      outerRadius = radius! + 6;
    }
    return BlocBuilder<UserCubit, UserState>(builder: (context, state1) {
      return Container(
        width: mq.width * 0.9,
        // height: 150,
        color: Colors.transparent,
        // alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: title != null,
              child: Text(
                title ?? tr("photos"),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 80,
              child: ListView.builder(
                  physics: isEnableScrolling
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: min(
                      state1.profileImagesList.length + 1,
                      BlocProvider.of<UserCubit>(context).state.isPremiumUser
                          ? 10
                          : 4),
                  itemBuilder: (ctx, index) {
                    if (index >= state1.profileImagesList.length) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: outerRadius,
                            width: outerRadius,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return ImagePickerModalBottomSheet();
                                      });
                                },
                                icon: const Center(
                                    child: Icon(Icons.add,
                                        size: 30, color: Colors.black))),
                          ),
                        ],
                      );
                    }
                    String imgPath = state1.profileImagesList[index].localUrl;
                    int id = state1.profileImagesList[index].id;
                    bool isActive = state1.profileImagesList[index].isActive;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: isActive == true
                                ? null
                                : () {
                                    if (onSelect != null) {
                                      onSelect!(imgPath);
                                    }
                                    BlocProvider.of<UserCubit>(context)
                                        .profileImagesListOperations(
                                            changeActiveStatus: true,
                                            photoIdToActive: id);
                                  },
                            child: Stack(
                              // alignment: AlignmentDirectional.center,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: isActive
                                            ? AppColors.primaryColor
                                            : Colors.grey.withOpacity(0.2),
                                        width: 3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(imgPath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: isActive == true
                                      ? IconButton(
                                          onPressed: kDebugMode
                                              ? () {
                                                  BlocProvider.of<UserCubit>(
                                                          context)
                                                      .profileImagesListOperations(
                                                          deletePhoto: true,
                                                          photoIdToDelete: id);
                                                }
                                              : null,
                                          icon: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                AppImages.selectedBadge),
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            BlocProvider.of<UserCubit>(context)
                                                .profileImagesListOperations(
                                                    deletePhoto: true,
                                                    photoIdToDelete: id);
                                          },
                                          icon: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              color: Colors.black,
                                              Icons.close,
                                              size: 15,
                                            ),
                                          )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
