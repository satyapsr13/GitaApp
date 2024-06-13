// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/enums.dart';
import '../../../Logic/Cubit/ToolsCubit/tools_cubit.dart';
import '../../Widgets/Buttons/primary_button.dart';

class BgRemoverScreen extends StatelessWidget {
  const BgRemoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Remove Bg'),
        ),
        body: BlocBuilder<ToolsCubit, ToolsState>(builder: (context, state) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          // title: title,
                          backgroundColor: Colors.transparent,
                          content: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                          'https://picsum.photos/200'),
                                      SizedBox(height: 15),
                                      Text(
                                        ' lorem ' * 20,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(),
                                      ),
                                      SizedBox(height: 15),
                                      PrimaryButton(
                                          onPressed: () {}, buttonText: "Done")
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -5,
                                top: -5,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      size: 20,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          )
                          // actions: [
                          //   TextButton(
                          //     onPressed: (){},
                          //     child: Text('CANCEL'),
                          //   ),
                          //   TextButton(
                          //     onPressed: () {},
                          //     child: Text('ACCEPT'),
                          //   ),
                          // ],
                          );
                    },
                  );
                  // BlocProvider.of<ToolsCubit>(context)
                  //     .removeBG(
                  //         imagePath: BlocProvider.of<UserCubit>(context)
                  //             .state
                  //             .profileImagesList[1]
                  //             .localUrl)
                  //     .then((value) {

                  // });
                  // BlocProvider.of<UserCubit>(context)
                  //     .profileImagesListOperations(
                  //         addProfile: true,
                  //         photo: ProfilePhotos(
                  //             localUrl: state.imageWithRemovedBg,
                  //             isActive: false,
                  //             id: BlocProvider.of<UserCubit>(context,
                  //                     listen: false)
                  //                 .state
                  //                 .getUniquePhotoId()));
                },
                child: state.status == Status.loading
                    ? CircularProgressIndicator()
                    : Text(
                        'Remove BG',
                        style: const TextStyle(),
                      ),
              )
            ],
          );
        }));
  }
}
