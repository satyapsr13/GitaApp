import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gita/Constants/colors.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../../Constants/constants.dart';
import '../../../../../Constants/enums.dart';
import '../../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Widgets/Buttons/circular_color.button.dart';
import '../../post_edit_screen.dart';
import '../font_dropdown.widget.dart';

class EditorDateWidget extends StatelessWidget {
  // const EditorDateWidget({super.key});

  final GlobalKey<FormBuilderState> formKey;

  const EditorDateWidget({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child:
            BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        BlocProvider.of<StickerCubit>(context)
                            .updateStateVariables(
                                editorWidgets: EditorWidgets.none);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 15),
                  Expanded(child: FontDropdownWidget(width: mq.width * 0.45)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<StickerCubit>(context)
                            .updateStateVariables(
                                editorWidgets: EditorWidgets.none);
                        BlocProvider.of<PostEditorCubit>(context)
                            .customTextStylesOperations(
                                isAddOperation: true, index: 0);
                      },
                      child: Container(
                        height: 50,
                        width: mq.width * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.primaryColor.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add),
                                Text(
                                  tr('add_another_txt'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: mq.width * 0.9,
                    child: FormBuilderTextField(
                      name: 'date',
                      maxLines: 3,
                      initialValue: state.dateStickerText,
                      onChanged: (val) {
                        BlocProvider.of<StickerCubit>(context)
                            .updateStateVariables(
                                hideCancelButton: false,
                                dateStickerText: val.toString(),
                                isDateVisible: true);
                      },
                      decoration: InputDecoration(
                        hintText: tr("your_thought"),
                        border: const OutlineInputBorder(
                            gapPadding: 0,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Column(
                  //   children: [
                  //     SizedBox(height: 5),

                  //   ],
                  // ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: state.isDateStickerVisible,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: state.dateFontSize,
                          onChanged: (val) {
                            BlocProvider.of<StickerCubit>(context)
                                .updateStateVariables(fontSize: val);
                          },
                          min: 8,
                          max: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  // const Spacer(),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: mq.height * 0.35,
                      // width: mq.width * 0.75,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: GridView.builder(
                          itemCount: state.tagListFromBackend.length + 6,
                          itemBuilder: (ctx, index) {
                            if (index >= state.tagListFromBackend.length) {
                              return const SizedBox(height: 20);
                            }
                            String data = state.tagListFromBackend[index];
                            return InkWell(
                              onTap: () {
                                formKey.currentState?.fields['date']
                                    ?.didChange(data);
                                BlocProvider.of<StickerCubit>(context)
                                    .updateStateVariables(
                                        hideCancelButton: false,
                                        dateStickerText: data,
                                        isDateVisible: true);
                              },
                              child: Card(
                                elevation: 2,
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: FittedBox(
                                        child: StrokeText(
                                          text: data,
                                          textStyle: Constants
                                              .googleFontStyles[state.fontIndex]
                                              .copyWith(
                                                  color: state.dateColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  backgroundColor: (state
                                                                  .dateColor ==
                                                              Colors.white &&
                                                          state.dateBorderColor ==
                                                              Colors
                                                                  .transparent)
                                                      ? Colors.black
                                                      : null),
                                          strokeColor: state.dateBorderColor,
                                          strokeWidth: 2,
                                        ),
                                      )),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5), // const Spacer(),
                  SizedBox(
                      height: mq.height * 0.35,
                      width: 50,
                      child: ListView(
                        // itemCount: Constants.colorList.length,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                // void changeColor(Color color) {

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.cancel,
                                              size: 30,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: mq.width * 0.7,
                                      height: mq.height * 0.4,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // SizedBox(
                                          //   width: mq.width * 0.7,
                                          //   height: 50,
                                          //   child: GridView.builder(
                                          //     itemCount: 1,
                                          //     itemBuilder: (ctx, index) {
                                          //       Color color =
                                          //           Constants.colorList[index];

                                          //       return InkWell(
                                          //           onTap: () {
                                          //             BlocProvider.of<
                                          //                         StickerCubit>(
                                          //                     context)
                                          //                 .updateStateVariables(
                                          //               fontColor: color,
                                          //             );
                                          //           },
                                          //           child: CircularColorButton(
                                          //             color: color,
                                          //           ));
                                          //     },
                                          //     gridDelegate:
                                          //         const SliverGridDelegateWithFixedCrossAxisCount(
                                          //             crossAxisCount: 4,
                                          //             childAspectRatio: 1,
                                          //             crossAxisSpacing: 0,
                                          //             mainAxisSpacing: 0),
                                          //   ),
                                          // ),
                                          CColorPicker(
                                            onColorTap: (color) {
                                              BlocProvider.of<StickerCubit>(
                                                      context)
                                                  .updateStateVariables(
                                                fontColor: color,
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Ok',
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,

                                      borderRadius: BorderRadius.circular(5),
                                      color: state.dateColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Text Color',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.cancel,
                                              size: 30,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    content: 1 == 1
                                        ? SizedBox(
                                            width: mq.width * 0.7,
                                            height: mq.height * 0.4,
                                            child: CColorPicker(
                                              isTransparentButton: true,
                                              onColorTap: (color) {
                                                BlocProvider.of<StickerCubit>(
                                                        context)
                                                    .updateStateVariables(
                                                  dateBorderColor: color,
                                                );
                                              },
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              1 == 1
                                                  ? CColorPicker(
                                                      isTransparentButton: true,
                                                      onColorTap: (color) {
                                                        BlocProvider.of<
                                                                    StickerCubit>(
                                                                context)
                                                            .updateStateVariables(
                                                          dateBorderColor:
                                                              color,
                                                        );
                                                      },
                                                    )
                                                  : SizedBox(
                                                      width: mq.width * 0.7,
                                                      height: mq.height * 0.5,
                                                      child: GridView.builder(
                                                        itemCount: Constants
                                                                .colorList
                                                                .length +
                                                            1,
                                                        itemBuilder:
                                                            (ctx, index) {
                                                          bool
                                                              isTransparentColor =
                                                              index >=
                                                                  Constants
                                                                      .colorList
                                                                      .length;
                                                          Color color =
                                                              isTransparentColor
                                                                  ? Colors
                                                                      .transparent
                                                                  : Constants
                                                                          .colorList[
                                                                      index];

                                                          return InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            StickerCubit>(
                                                                        context)
                                                                    .updateStateVariables(
                                                                        dateBorderColor:
                                                                            color);
                                                              },
                                                              child: CircularColorButton(
                                                                  color: color,
                                                                  isTransparentColor:
                                                                      isTransparentColor));
                                                        },
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    4,
                                                                childAspectRatio:
                                                                    1,
                                                                crossAxisSpacing:
                                                                    0,
                                                                mainAxisSpacing:
                                                                    0),
                                                      ),
                                                    ),
                                              // InkWell(
                                              //     onTap: () {
                                              //       BlocProvider.of<StickerCubit>(
                                              //               context)
                                              //           .updateStateVariables(
                                              //               dateBorderColor:
                                              //                   Colors.transparent);
                                              //     },
                                              //     child: const CircularColorButton(
                                              //         color: Colors.white,
                                              //         isTransparentColor: true))
                                            ],
                                          ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Ok',
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: state.dateBorderColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Border Color',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 5),
            ],
          );
        }),
      ),
    );
  }
}
