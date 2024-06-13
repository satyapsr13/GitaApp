import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Constants/colors.dart';
import '../../Constants/enums.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../Utility/next_screen.dart';
import 'specific_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    // bool isEnglish= tr(key)
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state.status == Status.loading) {
        return const SizedBox(
            child: Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryColor)));
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: mq.width,
              child: GridView.builder(
                shrinkWrap: true,
                // physics: const BouncingScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.categoriesList.length,
                itemBuilder: (ctx, index) {
                  String name = state.categoriesList[index].name ?? "";
                  String hindi = state.categoriesList[index].hindi ?? "";
                  String image = state.categoriesList[index].image ?? "";
                  String postId = state.categoriesList[index].id.toString();
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<PostCubit>(context)
                          .state
                          .categoryWisePostList = [];
                      nextScreenWithFadeAnimation(
                          context,
                          SpecificCategoryScreen(
                            categoryTitleEnglish: name,
                            categoryTitleHindi: hindi,
                            postId: postId,
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              colorFilter: const ColorFilter.mode(
                                Color(
                                    0x25000000), // Set the color you want to apply
                                BlendMode.overlay, // Set the blend mode
                              ),
                              image: CachedNetworkImageProvider(
                                image,
                              ),
                              fit: BoxFit.cover)),
                      child: Center(
                        child: BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 55),
                            child: Text(
                              (tr("_a_") == "A") ? name : hindi,
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 350 / 219,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }
}
