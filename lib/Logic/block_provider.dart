import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Logic/Cubit/DpMakerCubit/dpmaker_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../Data/repositories/localization.dart';
import '../Data/repositories/post_repository.dart';
import '../Data/repositories/series_post_repository.dart';
import '../Data/repositories/sticker_repository.dart';
import '../Data/repositories/tools_repository.dart';
import '../Data/repositories/user_repository.dart';
import '../Data/services/secure_storage.dart';
import 'Cubit/AdmobCubit/admob_ads_cubit.dart';
import 'Cubit/PostEditorCubit/post_editor_cubit.dart';
import 'Cubit/Posts/posts_cubit.dart';
import 'Cubit/SeriesPostCubit/series_post_cubit.dart';
import 'Cubit/StickerCubit/sticker_cubit.dart';
import 'Cubit/TestCubit/test_cubit.dart';
import 'Cubit/ToolsCubit/tools_cubit.dart';
import 'Cubit/locale_cubit/locale_cubit.dart';
import 'Cubit/user_cubit/user_cubit.dart';
// import 'Cubit/video_cubit/video_cubit.dart';

Future<List<BlocProvider>> getBlocProviders(
    SecureStorage secureStorage, HydratedStorage hydratedStorage) async {
  // system utilities
  // final Connectivity connectivity = Connectivity();
  final LocaleRepository localeRepository = LocaleRepository();
  final PostRepository postRepository = PostRepository();
  final StickerRepository stickerRepository = StickerRepository();
  final UserRepository userRepository = UserRepository();
  final SeriesPostRepository seriesPostRepository = SeriesPostRepository();
  final ToolsRepository toolsRepository = ToolsRepository();

  return [
    BlocProvider<LocaleCubit>(
        create: (context) => LocaleCubit(localeRepository: localeRepository)),
    BlocProvider<TestCubit>(
        create: (context) => TestCubit(
            stickerRepository: stickerRepository,
            userRepository: userRepository,
            toolsRepository: toolsRepository)),
    BlocProvider<DpMakerCubit>(
        create: (context) => DpMakerCubit(
            stickerRepository: stickerRepository,
            userRepository: userRepository,
            toolsRepository: toolsRepository)),
    BlocProvider<StickerCubit>(
        create: (context) => StickerCubit(
              localeRepository: localeRepository,
              stickerRepository: stickerRepository,

              // toolsCubit: context.read<ToolsCubit>(),
              // postState: context.read<PostCubit>(),
            )),
    BlocProvider<PostEditorCubit>(
        create: (context) =>
            PostEditorCubit(localeRepository: localeRepository)),
    // BlocProvider<AdmobCubit>(
    //     create: (context) => AdmobCubit(userRepository: userRepository)),
    BlocProvider<PostCubit>(
        create: (context) => PostCubit(
            localeRepository: localeRepository,
            postRepository: postRepository)),
    BlocProvider<UserCubit>(
        create: (context) => UserCubit(
            localeRepository: localeRepository,
            userRepository: userRepository,
            secureStorage: secureStorage)),
    BlocProvider<SeriesPostCubit>(
        create: (context) => SeriesPostCubit(
            localeRepository: localeRepository,
            seriesPostRepository: seriesPostRepository,
            secureStorage: secureStorage)),
    // BlocProvider<VideoCubit>(
    //     create: (context) => VideoCubit(
    //           localeRepository: localeRepository,
    //           // /secureStorage: secureStorage
    //         )),

    BlocProvider<AdmobCubit>(
        create: (context) => AdmobCubit(
              userRepository: userRepository,
              userCubit: context.read<UserCubit>(),
            )),
    BlocProvider<ToolsCubit>(
        create: (context) => ToolsCubit(
              toolsRepository: toolsRepository,
            )),
  ];
}
