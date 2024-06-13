import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Constants/enums.dart';
import '../../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../post_edit_screen.dart'; 
class EditorColorWidget extends StatelessWidget {
  const EditorColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<StickerCubit>(context).updateStateVariables(
                        editorWidgets: EditorWidgets.none);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                  )),
            ],
          ),
          CColorPicker(
            onColorTap: (color) {
              BlocProvider.of<PostEditorCubit>(context)
                  .updateStateVariables(customFrameColor: color,);

              // setState(() {
              //   userNameColor =
              //       color;
              // });
            },
          ),
          // const SizedBox(height: 20),
          // circularColorPicker("red", context),
          // circularColorPicker("pink", context),
          // circularColorPicker("black", context),
          // circularColorPicker("deepOrange", context),
          // circularColorPicker("yellow", context),
          // circularColorPicker("blue", context),
          // circularColorPicker("green", context),
          // circularColorPicker("white", context),
          // const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     TextButton(
          //       onPressed: () {
          //         BlocProvider.of<PostEditorCubit>(context)
          //             .updateStateVariables(tagColor: "transparent");
          //       },
          //       child: const Text(
          //         'Remove Color',
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
