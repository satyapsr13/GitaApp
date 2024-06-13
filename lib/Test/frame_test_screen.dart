import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Constants/enums.dart';
import '../Constants/locations.dart';
import '../Data/model/ObjectModels/post_widget_model.dart';
import '../Data/model/api/frames_response.dart';
import '../Logic/Cubit/TestCubit/test_cubit.dart';
import '../Presentation/Screens/PostsScreens/PostFrames/post_frames.dart';
import '../Presentation/Widgets/frame_to_frame_details.dart';
import '../Presentation/Widgets/post_widget.dart';

// import 'editor_date_tag_widget.dart';
class FrameTestScreen extends StatefulWidget {
  const FrameTestScreen({super.key});

  @override
  State<FrameTestScreen> createState() => _FrameTestScreenState();
}

class _FrameTestScreenState extends State<FrameTestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<TestCubit>(context).fetchFrames();
    super.initState();
  }

  bool isProfile = false;
  bool isName = false;
  bool isoccupation = false;
  bool number = false;
  final TextEditingController nameXController =
      TextEditingController(text: "5");
  final TextEditingController nameYController = TextEditingController();
  final TextEditingController occupationXController =
      TextEditingController(text: "5");
  final TextEditingController occupationYController = TextEditingController();
  final TextEditingController numberXController =
      TextEditingController(text: "5");
  final TextEditingController numberYController = TextEditingController();
  final TextEditingController profileXController =
      TextEditingController(text: "75");
  final TextEditingController profileYController = TextEditingController();
  double nameX = 0.0;
  double nameY = 0.0;
  double occupationX = 0.0;
  double occupationY = 0.0;
  double numberX = 0.0;
  double numberY = 0.0;
  double profileX = 0.0;
  double profileY = 0.0;
  @override
  Widget build(BuildContext context) {
    final testCubit = BlocProvider.of<TestCubit>(context);

    final mq = MediaQuery.of(context).size;
    PostWidgetModel postWidgetData = PostWidgetModel(
      index: 1,
      imageLink:
          "https://manage.connectup.in/rishteyy/quotes/quoteshindi/motivational/p2_i3_1673443183.jpg",
      postId: "1",
      profilePos: "right",
      profileShape: "round",
      tagColor: "white",
      playStoreBadgePos: "right",
      showName: true,
      showProfile: true,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Frame Test Screen'),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<TestCubit, TestState>(builder: (context, state) {
            if (state.status == Status.loading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Ruk ja Bhai load hone de',
                    style: TextStyle(),
                  ),
                  CircularProgressIndicator()
                ],
              );
            }
            return Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // PostWidget(postWidgetData: postWidgetData),
                    Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 250,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Image.network(
                                        postWidgetData.imageLink,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                              child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child:
                                                RishteyyShimmerLoader(mq: mq),
                                          ));
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
                                                  child: SizedBox(
                                                      height: 100,
                                                      width: 200,
                                                      child: Image.asset(
                                                        AppImages.rishteyTag,
                                                        fit: BoxFit.contain,
                                                      )),
                                                )),
                                  ),
                                  state.currentFrame == null
                                      ? const SizedBox(height: 15)
                                      : FrameWidget(
                                          frameDetails: frameToFrameDetails(
                                              state.currentFrame!,
                                              constraints.maxWidth))
                                ],
                              );
                            })),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    SizedBox(
                      height: 150,
                      width: mq.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.listOfTestFrames.length,
                          itemBuilder: (ctx, index) {
                            Frame frame = state.listOfTestFrames[index];
                            return InkWell(
                              onTap: () {
                                final testState =
                                    BlocProvider.of<TestCubit>(context).state;
                                BlocProvider.of<TestCubit>(context)
                                    .updateStateVariable(
                                        currentFrame:
                                            testState.currentFrame?.copyWith(
                                  name: testState.currentFrame?.name?.copyWith(
                                    x: num.tryParse(nameXController.text),
                                    y: num.tryParse(nameYController.text),
                                  ),
                                  occupation: testState.currentFrame?.occupation
                                      ?.copyWith(
                                    x: num.tryParse(occupationXController.text),
                                    y: num.tryParse(occupationYController.text),
                                  ),
                                  number:
                                      testState.currentFrame?.number?.copyWith(
                                    x: num.tryParse(numberXController.text),
                                    y: num.tryParse(numberYController.text),
                                  ),
                                  profile: testState.currentFrame?.profile
                                      ?.copyWith(
                                          x: num.tryParse(
                                              profileXController.text),
                                          y: num.tryParse(
                                              profileYController.text),
                                          image: frame.profile?.image),
                                ));
                              },
                              onDoubleTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("_"),
                                        content: SelectableText(
                                            frame.profile?.image ?? ""),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text("OK"),
                                            onPressed: () {},
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 70,
                                    width: 150,
                                    child: Image.network(
                                        frame.profile?.image ?? "")),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        _submitCoordinates();
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(height: 16.0),
                    _buildCoordinateFields(
                      'Name',
                      nameXController,
                      nameYController,
                    ),
                    _buildCoordinateFields(
                      'Occupation',
                      occupationXController,
                      occupationYController,
                    ),
                    _buildCoordinateFields(
                      'Number',
                      numberXController,
                      numberYController,
                    ),
                    _buildCoordinateFields(
                      'Profile',
                      profileXController,
                      profileYController,
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              );
            });
          }),
        ));
  }

  Widget _buildCoordinateFields(String label, TextEditingController xController,
      TextEditingController yController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        // SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: xController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'X ',
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: yController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Y '),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }

  Widget _buildCoordinateSlider(
    String label,
    double xValue,
    ValueChanged<double> onXChanged,
    double yValue,
    ValueChanged<double> onYChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: xValue,
                min: 0.0,
                max: 100.0,
                onChanged: onXChanged,
                divisions: 100,
                label: xValue.toStringAsFixed(2),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Slider(
                value: yValue,
                min: 0.0,
                max: 100.0,
                onChanged: onYChanged,
                divisions: 100,
                label: yValue.toStringAsFixed(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void _submitCoordinates() {
    final testState = BlocProvider.of<TestCubit>(context).state;
    BlocProvider.of<TestCubit>(context).updateStateVariable(
        currentFrame: testState.currentFrame?.copyWith(
      name: testState.currentFrame?.name?.copyWith(
        x: num.tryParse(nameXController.text),
        y: num.tryParse(nameYController.text),
      ),
      occupation: testState.currentFrame?.occupation?.copyWith(
        x: num.tryParse(occupationXController.text),
        y: num.tryParse(occupationYController.text),
      ),
      number: testState.currentFrame?.number?.copyWith(
        x: num.tryParse(numberXController.text),
        y: num.tryParse(numberYController.text),
      ),
      profile: testState.currentFrame?.profile?.copyWith(
        x: num.tryParse(profileXController.text),
        y: num.tryParse(profileYController.text),
      ),
    ));
  }
}

// class PostPreviewWidget extends StatefulWidget {
//   const PostPreviewWidget({
//     Key? key,
//     required this.screenshotController,
//     required this.outerBorderRadius,
//     required this.postSize,
//     required this.userPickedImage,
//     this.makePostFromGallery,
//     this.postWidgetModel,
//     required this.userNameColor,
//   }) : super(key: key);

//   final ScreenshotController screenshotController;
//   final double outerBorderRadius;
//   final double postSize;
//   final bool? makePostFromGallery;
//   final File? userPickedImage;
//   final PostWidgetModel? postWidgetModel;
//   final Color userNameColor;

//   @override
//   State<PostPreviewWidget> createState() => _PostPreviewWidgetState();
// }

// class _PostPreviewWidgetState extends State<PostPreviewWidget> {
//   final GlobalKey _imageKey = GlobalKey();
//   // double _imageHeight = 200;
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // _getImageHeight();
//   // }

//   double extendedHeight = 70;

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     double maxWid = mq.width - 30;

//     extendedHeight = (maxWid / 3) - 12 - (maxWid / 9);

//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Card(
//         elevation: 5,
//         child: Screenshot(
//             controller: widget.screenshotController,
//             child: BlocBuilder<StickerCubit, StickerState>(
//                 builder: (context, stickerState) {
//               return BlocBuilder<PostEditorCubit, PostEditorState>(
//                   builder: (context, postEditorState) {
//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     (postEditorState.isAdvanceEditorMode)
//                         ? Visibility(
//                             visible: true,
//                             child: StickerDraggingWidget(
//                               // maxYPos: _imageHeight+40,
//                               isDragEnable: !stickerState.hideCancelButton,
//                               xPos: postEditorState.profileInitialPos.dx,
//                               yPos: postEditorState.profileInitialPos.dy,
//                               body: Stack(
//                                 children: [
//                                   stickerState.hideCancelButton == true
//                                       ? Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: ImageTagForEditor(
//                                             onImageTap: () {
//                                               BlocProvider.of<StickerCubit>(
//                                                       context)
//                                                   .updateStateVariables(
//                                                       hideCancelButton: false,
//                                                       editorWidgets: EditorWidgets
//                                                           .profileSizeAndShape);
//                                               BlocProvider.of<PostEditorCubit>(
//                                                       context)
//                                                   .updateStateVariables(
//                                                       profilePos: "right",
//                                                       isAdvanceEditorMode:
//                                                           !postEditorState
//                                                               .isAdvanceEditorMode);
//                                             },
//                                             profileShape:
//                                                 postEditorState.profileShape,
//                                           ),
//                                         )
//                                       : DottedBorder(
//                                           color:
//                                               stickerState.hideCancelButton ==
//                                                       true
//                                                   ? Colors.transparent
//                                                   : Colors.white,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: ImageTagForEditor(
//                                               onImageTap: () {
//                                                 BlocProvider.of<StickerCubit>(
//                                                         context)
//                                                     .updateStateVariables(
//                                                         hideCancelButton: false,
//                                                         editorWidgets: EditorWidgets
//                                                             .profileSizeAndShape);
//                                                 BlocProvider.of<
//                                                             PostEditorCubit>(
//                                                         context)
//                                                     .updateStateVariables(
//                                                   isAdvanceEditorMode:
//                                                       !postEditorState
//                                                           .isAdvanceEditorMode,
//                                                 );
//                                               },
//                                               profileShape:
//                                                   postEditorState.profileShape,
//                                             ),
//                                           ),
//                                         ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Positioned(
//                             right: postEditorState
//                                         .currentFrame?.profile?.position !=
//                                     "left"
//                                 ? 10
//                                 : null,
//                             left: postEditorState
//                                         .currentFrame?.profile?.position !=
//                                     "left"
//                                 ? null
//                                 : 10,
//                             bottom: 10,
//                             child: ImageTagForEditor(
//                               onImageTap: () {
//                                 BlocProvider.of<StickerCubit>(context)
//                                     .updateStateVariables(
//                                         hideCancelButton: false,
//                                         editorWidgets:
//                                             EditorWidgets.profileSizeAndShape);
//                                 BlocProvider.of<PostEditorCubit>(context)
//                                     .updateStateVariables(
//                                   isAdvanceEditorMode: true,
//                                 );
//                               },
//                               profileShape: postEditorState.profileShape,
//                             ),
//                           ),
//                     Visibility(
//                       visible: stickerState.isDateStickerVisible,
//                       child: StickerDraggingWidget(
//                         // maxYPos: _imageHeight,
//                         isDragEnable: !stickerState.hideCancelButton,
//                         body: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             DottedBorder(
//                               color: stickerState.hideCancelButton
//                                   ? Colors.transparent
//                                   : Colors.white,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(3.0),
//                                 child: SizedBox(
//                                     child: StrokeText(
//                                   text: stickerState.dateStickerText,
//                                   textStyle: Constants
//                                       .googleFontStyles[stickerState.fontIndex]
//                                       .copyWith(
//                                           color: stickerState.dateColor,
//                                           fontSize: stickerState.dateFontSize,
//                                           fontWeight: FontWeight.bold),
//                                   strokeColor: stickerState.dateBorderColor,
//                                   strokeWidth: 5,
//                                 )),
//                               ),
//                             ),
//                             stickerState.hideCancelButton
//                                 ? const SizedBox()
//                                 : Positioned(
//                                     top: -20,
//                                     right: -20,
//                                     child: IconButton(
//                                         onPressed: () {
//                                           BlocProvider.of<StickerCubit>(context)
//                                               .updateStateVariables(
//                                                   isDateVisible: false);
//                                         },
//                                         icon: const Icon(
//                                           Icons.cancel_outlined,
//                                           color: Colors.red,
//                                           size: 20,
//                                         )),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     ...List.generate(
//                         stickerState.listOfActiveUserStickers.length, (index) {
//                       final StickerFromAssets sticker =
//                           stickerState.listOfActiveUserStickers[index];
//                       return StickerDraggingWidget(
//                         isDragEnable: !stickerState.hideCancelButton,
//                         body: Stack(
//                           children: [
//                             DottedBorder(
//                               color: stickerState.hideCancelButton
//                                   ? Colors.transparent
//                                   : Colors.white,
//                               child: SizedBox(
//                                 height:
//                                     stickerState.listOfUserStickerSides[index],
//                                 width:
//                                     stickerState.listOfUserStickerSides[index],
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(3.0),
//                                   child: Image.file(
//                                     File(sticker.imageLink),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             stickerState.hideCancelButton
//                                 ? const SizedBox()
//                                 : Positioned(
//                                     top: -5,
//                                     right: -5,
//                                     child: IconButton(
//                                         onPressed: () {
//                                           BlocProvider.of<StickerCubit>(context)
//                                               .userStickerOperations(
//                                                   imageUrl: sticker.imageLink,
//                                                   isDelete: true,
//                                                   isOperationForAddingInEditor:
//                                                       true);
//                                         },
//                                         icon: const Icon(
//                                           Icons.cancel_outlined,
//                                           color: Colors.red,
//                                           size: 20,
//                                         )),
//                                   ),
//                           ],
//                         ),
//                       );
//                     }),
//                     ...List.generate(stickerState.stickerDList.length, (index) {
//                       final StickerFromNetwork sticker =
//                           stickerState.stickerDList[index];
//                       return false
//                           ? EditWrapper(
//                               body: SizedBox(
//                                 height: 100,
//                                 width: 100,
//                                 child: CachedNetworkImage(
//                                   imageUrl: sticker.imageLink,
//                                   fit: BoxFit.cover,
//                                   imageBuilder: (context, imageProvider) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   placeholder: (context, url) => const Center(
//                                       child: CircularProgressIndicator(
//                                     color: Colors.orange,
//                                   )),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                 ),
//                               ),
//                             )
//                           : StickerDraggingWidget(
//                               isDragEnable: !stickerState.hideCancelButton,
//                               body: Stack(
//                                 children: [
//                                   DottedBorder(
//                                     color: stickerState.hideCancelButton
//                                         ? Colors.transparent
//                                         : Colors.white,
//                                     child: SizedBox(
//                                       height:
//                                           stickerState.stickerDListSides[index],
//                                       width:
//                                           stickerState.stickerDListSides[index],
//                                       child: CachedNetworkImage(
//                                         imageUrl: sticker.imageLink,
//                                         fit: BoxFit.cover,
//                                         imageBuilder: (context, imageProvider) {
//                                           return Container(
//                                               decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.fill,
//                                           )));
//                                         },
//                                         placeholder: (context, url) =>
//                                             const Center(
//                                                 child:
//                                                     CircularProgressIndicator(
//                                           color: Colors.orange,
//                                         )),
//                                         errorWidget: (context, url, error) =>
//                                             const Icon(Icons.error),
//                                       ),
//                                     ),
//                                   ),
//                                   stickerState.hideCancelButton
//                                       ? const SizedBox()
//                                       : Positioned(
//                                           top: -5,
//                                           right: -5,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 BlocProvider.of<StickerCubit>(
//                                                         context)
//                                                     .stickerOperation(
//                                                         isRemoveSticker: true,
//                                                         stickerId: sticker.id,
//                                                         index: index);
//                                               },
//                                               icon: const Icon(
//                                                 Icons.cancel_outlined,
//                                                 color: Colors.red,
//                                                 size: 20,
//                                               )),
//                                         ),
//                                 ],
//                               ),
//                             );
//                     }),
//                     Visibility(
//                       visible: postEditorState.isDateTagVisible,
//                       child: postEditorState.datePosition == DatePos.dragging
//                           ? StickerDraggingWidget(
//                               isDragEnable: !stickerState.hideCancelButton,
//                               body: Stack(
//                                 children: [
//                                   !stickerState.hideCancelButton
//                                       ? DottedBorder(
//                                           color: Colors.white,
//                                           child: EditorDateTagWidget(
//                                             isDateEditable: true,
//                                           ),
//                                         )
//                                       : EditorDateTagWidget(
//                                           isDateEditable: true,
//                                         ),
//                                   stickerState.hideCancelButton
//                                       ? const SizedBox()
//                                       : Positioned(
//                                           top: -15,
//                                           right: -15,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 BlocProvider.of<
//                                                             PostEditorCubit>(
//                                                         context)
//                                                     .updateStateVariables(
//                                                         isDateTagVisible:
//                                                             false);
//                                               },
//                                               icon: const Icon(
//                                                 Icons.cancel_outlined,
//                                                 color: Colors.red,
//                                                 size: 20,
//                                               )),
//                                         ),
//                                 ],
//                               ))
//                           : Positioned(
//                               top: 10,
//                               left: getDatePosition(
//                                   datePosition: postEditorState.datePosition,
//                                   isLeft: true),
//                               right: getDatePosition(
//                                   datePosition: postEditorState.datePosition,
//                                   isLeft: false),
//                               child: EditorDateTagWidget(),
//                             ),
//                     ),
//                   ],
//                 );
//               });
//             })),
//       ),
//     );
//   }
// }
