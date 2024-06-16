import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:gita/Data/model/api/message_response.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Data/model/ObjectModels/saved_post_model.dart';
import '../../../Data/model/ObjectModels/user.model.dart';
import '../../../Data/model/api/Premium/premium_plan_response.dart';
import '../../../Data/model/api/Premium/subscribe_plan_list_response.dart';
import '../../../Data/model/api/category_model.dart';
import '../../../Data/model/api/getprofile.response.dart';
import '../../../Data/model/api/leaderboard_response.dart';
import '../../../Data/repositories/localization.dart';
import '../../../Data/repositories/user_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';
import '../../../Data/services/secure_storage.dart';

part 'user_state.dart';

class UserCubit extends HydratedCubit<UserState> {
  final LocaleRepository localeRepository;
  final UserRepository userRepository;
  final SecureStorage secureStorage;
  UserCubit({
    required this.localeRepository,
    required this.userRepository,
    required this.secureStorage,
  }) : super(const UserState());

  Future<void> authorizeUser({required UserModel user}) async {
    Logger().e("isAdmin 2");
    ApiResult<dynamic> categoriesResponse = await userRepository.authorizeUser(
        user.copyWith(
            profileUrl:
                state.uploadedImage.isEmpty ? null : state.uploadedImage));

    categoriesResponse.when(success: (dynamic data) async {
      // Logger().e("isAdmin 3 ${data}");
      await secureStorage.saveTokeInDB(data["data"]["token"].toString());
      int userId = int.parse((data["data"]["user"]["id"] ?? -1).toString());
      // Logger().i(data);
      emit(state.copyWith(
        isAuthenticatedUser: true,
        isLoggedIn: true,
        userId: userId,
        isPremiumUser: data["data"]["is_premium"] == true,
        status: Status.authSuccess,
      ));
      if (userId > 0) {
        await secureStorage.storeLocally(
            key: "userId", value: userId.toString());
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          loginError: NetworkExceptions.getErrorMessage(error)));
      sendRatingFeedback(
        message: "Error in login $error",
        reason: GErrorVar.errorLogin,
      );
    });
  }

  Future<void> getMessages({int pageNo = 1}) async {
    emit(state.copyWith(
      messageStatus: pageNo > 1 ? Status.loadingNextPage : Status.loading,
    ));
    ApiResult<MessageResponse> categoriesResponse =
        await userRepository.getMessages(pageNo: pageNo);

    categoriesResponse.when(success: (MessageResponse data) async {
      emit(state.copyWith(
          messageStatus: Status.success, messageData: data.data));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          messageStatus: Status.failure,
          loginError: NetworkExceptions.getErrorMessage(error)));
    });
  }

  Future<void> sendMessages({required Message message}) async {
    emit(state.copyWith(
        sendMessageStatus: Status.loading,
        messageData: state.messageData?.copyWith(data: [
          message.copyWith(
            userId: state.userId,
            active: 1,
            toUserId: state.userId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...state.messageData!.data!,
        ])));
    ApiResult<MessageResponse> categoriesResponse =
        await userRepository.sendMessages(
            message: message.copyWith(
      userId: state.userId,
      active: 1,
      toUserId: state.userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    categoriesResponse.when(success: (MessageResponse data) async {
      emit(state.copyWith(
        sendMessageStatus: Status.success,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          sendMessageStatus: Status.failure,
          loginError: NetworkExceptions.getErrorMessage(error)));
    });
  }

  Future<void> fetchSubscribePlans() async {
    // Logger().e("isAdmin 2");
    emit(state.copyWith(
      subscriptionPlansStatus: Status.loading,
    ));
    ApiResult<SubscribePlanListResponse> categoriesResponse =
        await userRepository.fetchSubscribePlans();

    categoriesResponse.when(success: (SubscribePlanListResponse data) async {
      emit(state.copyWith(
        subscriptionPlansStatus: Status.success,
        listOfSubscribePlans: data.data,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        subscriptionPlansStatus: Status.failure,
      ));
      sendRatingFeedback(
        message: "Error in fetchind subscription plans $error",
        reason: "error_in_fetching_subscription",
      );
    });
  }

  Future<void> updateProfile(UserModel user) async {
    ApiResult<dynamic> response = await userRepository.updateProfile(
        user.copyWith(
            profileUrl:
                state.uploadedImage.isEmpty ? null : state.uploadedImage));

    response.when(success: (dynamic data) async {
      emit(state.copyWith(isAuthenticatedUser: true));
    }, failure: (NetworkExceptions error) {
      sendRatingFeedback(
        message: "Error in profile update $error",
        reason: GErrorVar.errorLogin,
      );
    });
  }

  Future<void> fetchPremiumPlan() async {
    emit(state.copyWith(premiumPlanStatus: Status.loading));
    ApiResult<PremiumPlanResponse> response =
        await userRepository.fetchPremiumPlan();

    response.when(success: (PremiumPlanResponse data) async {
      if (data.data != null) {
        Plan? selectedPlan;
        if ((data.data?.plans?.length ?? 0) >= 2) {
          selectedPlan = data.data?.plans?[1];
        }
        emit(state.copyWith(
            premiumPlanStatus: Status.success,
            premiumPlan: data.data,
            selectedPlan: selectedPlan));
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        premiumPlanStatus: Status.failure,
      ));
      sendRatingFeedback(
        message: "Error in fetching premiumPlan $error",
        reason: GErrorVar.errorLogin,
      );
    });
  }

  Future<void> getProfileData() async {
    emit(state.copyWith(getProfileStatus: Status.loading));
    ApiResult<GetProfileResponse> response =
        await userRepository.getProfileDate();

    response.when(success: (GetProfileResponse data) async {
      if (data.success == true) {
        bool isAdmin = (int.tryParse((data.data?.role ?? "").toString()) == 1);
        Logger().e("isAdmin $isAdmin");
        try {
          DateTime? varifiedTill =
              DateTime.tryParse((data.data?.verifiedTill).toString());

          Logger().e("isPremiumUserHai ${data.data?.isPremium}");

          emit(state.copyWith(
              userId: data.data?.id ?? state.userId,
              uploadedImage: data.data?.profilePhotoPath ?? "",
              isAdmin: isAdmin,
              varifiedTill: varifiedTill,
              isPremiumUser: data.data?.isPremium
              // userName:
              //     state.userName.isEmpty ? data.data?.username : state.userName,
              ));

          if ((data.data?.profilePhotoPath == null) ||
              (state.againUpdateProfileUrlInServer == true)) {
            if (state.fileImagePath.isNotEmpty) {
              uploadMedia(filePath: state.fileImagePath).then((value) {
                updateProfile(UserModel(name: state.userName));
              });
            }
          }
        } catch (e) {
          Logger().e("isPremiumUserHai 1 $e ${state.isPremiumUser}");
        }
      } else {
        Logger().e("isAdmin 2.5");
        if (state.userName.isNotEmpty) {
          authorizeUser(
              user: UserModel(
            name: state.userName,
            contact: state.userNumber,
            occupation: state.userOccupation,
          ));
        } else {
          emit(state.copyWith(getProfileStatus: Status.phoneNumberInvalid));
          emit(state.copyWith(getProfileStatus: Status.initial));
        }
      }
    }, failure: (NetworkExceptions error) {
      sendRatingFeedback(
        message: "Error in getProfile $error",
        reason: GErrorVar.errorLogin,
      );
    });
  }

  Future<void> sendRatingFeedback({
    required String message,
    String? channelName,
    String? reason,
  }) async {
    ApiResult<dynamic> response = await userRepository.sendRatingFeedback(
      userId: state.userId.toString(),
      message: message,
      number: state.userNumber,
      channelName: channelName,
      reason: reason,
    );

    response.when(
        success: (dynamic data) async {},
        failure: (NetworkExceptions error) {});
  }

  Future<void> savedPostDbOperations({
    bool? isDeleteOperation,
    bool? isAddOperation,
    String? postLinkToDelete,
    String? postLinkToAdd,
    int? postIdToAdd,
  }) async {
    emit(state.copyWith(status: Status.loading));
    SecureStorage storage = SecureStorage();
    List<SavedPost> data = await storage.getSharedPhotosList();
    if (isDeleteOperation == true) {
      if (postLinkToDelete != null) {
        data.removeWhere((element) => element.imageLink == postLinkToDelete);

        await storage.saveSharedPhotosList(data);
      }
    }
    if (isAddOperation == true) {
      if (postIdToAdd != null && postLinkToAdd != null) {
        bool isAlreadyPresent = false;
        for (var i = 0; i < data.length; i++) {
          if (data[i].postId == postIdToAdd) {
            isAlreadyPresent = true;
            break;
          }
        }
        if (isAlreadyPresent == false) {
          data.insert(
              0, SavedPost(postId: postIdToAdd, imageLink: postLinkToAdd));
          List<SavedPost> finalList = data.sublist(0, min(data.length, 60));
          data.clear();
          data.addAll(finalList);
          await storage.saveSharedPhotosList(data);
        }
      }
    }
    // List<SavedPost> finalData = await storage.getSharedPhotosList();
    emit(state.copyWith(savedPostList: data, status: Status.success));
  }

  Future<void> uploadMedia({required String filePath}) async {
    ApiResult<dynamic> categoriesResponse =
        await userRepository.uploadMedia(filePath);

    categoriesResponse.when(
        success: (dynamic data) async {
          emit(state.copyWith(
              uploadedImage: data["data"].toString(),
              againUpdateProfileUrlInServer: false));
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> fetchBlockedNumbers() async {
    ApiResult<dynamic> categoriesResponse =
        await userRepository.fetchBlockedNumbers();

    categoriesResponse.when(
        success: (dynamic data) async {
          final tempData = jsonDecode(json.encode(data));
          List<String> fetchedBlockedNumbers = [];
          for (final e in tempData["data"]) {
            fetchedBlockedNumbers.add(e);
          }

          emit(state.copyWith(
              listOfInvalidBlockedNumbers: fetchedBlockedNumbers));
          // Logger().e(jsonEncode(state.listOfInvalidBlockedNumbers));
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> profileImagesListOperations({
    bool? addProfile,
    bool? deletePhoto,
    bool? changeActiveStatus,
    int? photoIdToDelete,
    int? photoIdToActive,
    ProfilePhotos? photo,
  }) async {
    List<ProfilePhotos> photosList = await secureStorage.getProfilePhotos();

    if (addProfile == true) {
      if (photo != null) {
        if (photosList.length < 5) {
          for (final e in photosList) {
            if (e.localUrl == photo.localUrl) {
              return;
            }
          }
          photosList.add(photo);
          for (int i = 0; i < photosList.length; ++i) {
            photosList[i].id = i;
          }
          if (photosList.length == 1) {
            photosList[0].isActive = true;
          }
          await secureStorage.saveProfilePhotos(photosList);
        }
      }
    }
    if (deletePhoto == true) {
      if (photoIdToDelete != null) {
        photosList.removeWhere((element) => element.id == photoIdToDelete);
        await secureStorage.saveProfilePhotos(photosList);
      }
    }
    if (changeActiveStatus == true) {
      if (photoIdToActive != null) {
        for (int i = 0; i < photosList.length; ++i) {
          if (photosList[i].id == photoIdToActive) {
            photosList[i].isActive = true;
          } else {
            photosList[i].isActive = false;
          }
        }
        emit(state.copyWith(againUpdateProfileUrlInServer: true));
        await secureStorage.saveProfilePhotos(photosList);
      }
    }
    List<ProfilePhotos> finalPhotos = await secureStorage.getProfilePhotos();
    if (finalPhotos.isNotEmpty) {
      emit(state.copyWith(profileImagesList: finalPhotos));
      for (final e in finalPhotos) {
        if (e.isActive) {
          emit(state.copyWith(fileImagePath: e.localUrl));

          return;
        }
      }
    }
  }

  recoverFromLocalStorage({
    bool loadName = true,
    bool loadNumber = true,
    bool loadOccupation = true,
  }) async {
    if (state.userName.isEmpty && loadName) {
      String name = await secureStorage.getFirstName() ?? "";
      emit(state.copyWith(userName: name));
    }
    if (state.userNumber.isEmpty && loadNumber) {
      String name = await secureStorage.getNumber() ?? "";
      emit(state.copyWith(userNumber: name));
    }
    if (state.userOccupation.isEmpty && loadOccupation) {
      String name = await secureStorage.getOccupation() ?? "";
      emit(state.copyWith(userOccupation: name));
    }
  }

  Future<void> loadImageAndName({bool? isAddPhoto}) async {
    if (isAddPhoto == true) {
      String imagePath =
          await secureStorage.readLocally(SecureStorage.localPhotoPathKey);
      await profileImagesListOperations(
          addProfile: true,
          photo: ProfilePhotos(
              localUrl: imagePath,
              isActive: false,
              id: state.getUniquePhotoId()));
    } else {
      String imagePath = "";
      if (state.profileImagesList.isNotEmpty) {
        for (final e in state.profileImagesList) {
          if (e.isActive == true) {
            imagePath = e.localUrl;
            break;
          }
        }
      } else {
        imagePath =
            await secureStorage.readLocally(SecureStorage.localPhotoPathKey);
        await profileImagesListOperations();
      }

      if (imagePath.isNotEmpty) {
        emit(state.copyWith(fileImagePath: imagePath));
        //----------------Below function we have to call only one time remove that in next release ----------------------------------------------
        if (state.profileImagesList.isEmpty) {
          profileImagesListOperations(
              addProfile: true,
              photo: ProfilePhotos(localUrl: imagePath, isActive: true, id: 1));
        }
      }
      // print(
      //     "----------------checkingforname----1-----${state.userName}--------------------");
      String userName = state.userName.trim();
      // if (state.userName.trim().isEmpty) {
      // log("x")
      // print(
      //     "----------------checkingforname---------${state.userName}--------------------");
      // userName = await secureStorage.getFirstName() ?? "";
      // userName += " ";
      // userName += await secureStorage.getLastName() ?? "";

      // if (userName.isNotEmpty) {
      //   emit(state.copyWith(
      //     userName: userName.trim(),
      //   ));
      // }
      // }

      String userNumber = state.userNumber.trim();
      // if (state.userNumber.isEmpty) {
      // userNumber = await secureStorage.getNumber() ?? "";
      // if (userNumber.isNotEmpty) {
      //   emit(state.copyWith(userNumber: userNumber));
      // }
      // }
      if (!(userName.trim().isEmpty &&
          userNumber.trim().isEmpty &&
          imagePath.trim().isEmpty)) {
        secureStorage.storeLocally(
            key: "LOGIN_STATUS", value: "LoggedInOurApp");
      }
    }
  }

  Future<void> setEditName(String name) async {
    emit(state.copyWith(editedName: name));
  }

  Future<void> profileScreenUpdateButtonOperation({
    required String userName,
    required String userNumber,
    String? occupation,
  }) async {
    emit(state.copyWith(userProfileStatus: Status.loading));
    // print(
    //     "------------profileScreenUpdateButtonOperation--------$userName---------------");
    emit(state.copyWith(
        userOccupation: occupation,
        userName: userName,
        userNumber: userNumber));
    emit(state.copyWith(userProfileStatus: Status.updateSuccess));

    try {
      loadImageAndName().then((_) {
        uploadMedia(filePath: state.fileImagePath).then((_) {
          updateProfile(UserModel(
            name: userName,
          ));
        });
      });
    } catch (e) {}
  }

  saveToLocalStorage({
    String? userName,
    String? userNumber,
    String? userOccupation,
  }) async {
    if (userName != null) {
      await secureStorage.storeLocally(key: "NAME", value: userName);
    }
    if (userNumber != null) {
      await secureStorage.storeLocally(key: "NUMBER", value: userNumber);
    }
    if (userOccupation != null) {
      await secureStorage.storeLocally(
          key: SecureStorage.occupationKey, value: userOccupation);
    }
  }

  Future<void> loginScreenLoginButtonOperation({
    required String userName,
    required String userNumber,
    String? pickedImagePath,
    String? occupation,
    String? alternateMobileNumber,
  }) async {
    emit(state.copyWith(status: Status.loading));
    try {
      emit(state.copyWith(
          userName: userName,
          userNumber: userNumber,
          userOccupation: occupation));
      saveToLocalStorage(
          userName: userName,
          userNumber: userNumber,
          userOccupation: occupation);

      if (pickedImagePath != null) {
        emit(state.copyWith(fileImagePath: pickedImagePath));
        await uploadMedia(filePath: pickedImagePath).then((value) async {
          await authorizeUser(
              user: UserModel(
            name: userName,
            contact: userNumber,
            address: alternateMobileNumber,
          ));
        });
      } else {
        await authorizeUser(
            user: UserModel(
          name: userName,
          contact: userNumber,
          alternateNumber: alternateMobileNumber,
        ));
      }
    } catch (e) {
      sendRatingFeedback(
        message: "Error in Login Screen $e",
        reason: "error_loginscreen",
      );
    }
    // await secureStorage.storeLocally(
    //     key: "LOGIN_STATUS", value: "LoggedInOurApp");
  }

  Future<void> changeUserStateVariables({int? appVersion}) async {
    if (appVersion != null) {
      emit(state.copyWith(appVersion: appVersion));
    }
  }

  Future<void> sendPremiumPurchaseToBackend({
    bool? isSuccess,
    String? orderId,
    String? paymentId,
    String? signature,
    String? error,
  }) async {
    // Logger().i("sendPremiumPurchaseToBackend");
    emit(state.copyWith(paymentStatus: Status.loading));
    ApiResult<dynamic> response =
        await userRepository.sendPremiumPurchaseToBackend(
            orderId: orderId,
            paymentId: paymentId,
            signature: signature,
            isSuccess: isSuccess,
            error: error,
            planId: state.selectedPlan?.id,
            amount: state.selectedPlan?.price);

    response.when(success: (dynamic data) async {
      if (data['data'] == null) {
        emit(state.copyWith(
          paymentStatus: Status.success,
        ));
      } else {
        emit(state.copyWith(
            paymentStatus: Status.success,
            isPremiumUser: data["data"]["is_premium"] == true));
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        paymentStatus: Status.failure,
      ));
    });
    emit(state.copyWith(
      paymentStatus: Status.initial,
    ));
  }

  Future<void> dumpData({
    required String dummyData,
  }) async {
    ApiResult<dynamic> response = await userRepository.dumpData(
        number: state.userNumber,
        userId: state.userId.toString(),
        dummyData: dummyData);

    response.when(
        success: (dynamic data) async {},
        failure: (NetworkExceptions error) {});
  }

  Future<void> fetchLeaderboardData() async {
    emit(state.copyWith(
      leaderboardStatus: Status.loading,
    ));
    ApiResult<LeaderboardResponse> response =
        await userRepository.fetchLeaderboardData();

    response.when(success: (LeaderboardResponse data) async {
      emit(state.copyWith(
          leaderboardStatus: Status.success, leaderboardData: data.data));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        leaderboardStatus: Status.failure,
      ));
    });
  }

  void updateStateVariables({
    String? userName,
    String? editedName,
    String? fileImagePath,
    double? userAppRating,
    bool? isPremiumUser,
    bool? isAddLinkDuringShare,
    bool? isAdmin,
    int? lastTimeRenewNotificationShown,
    int? lastMessageId,
    Plan? selectedPlan,
    List<ProfilePhotos>? profileImagesList,
  }) async {
    try {
      emit(state.copyWith(
        profileImagesList: profileImagesList ?? state.profileImagesList,
        lastMessageId: lastMessageId ?? state.lastMessageId,
        lastTimeRenewNotificationShown: lastTimeRenewNotificationShown ??
            state.lastTimeRenewNotificationShown,
        userName: userName ?? state.userName,
        fileImagePath: fileImagePath ?? state.fileImagePath,
        isAdmin: isAdmin ?? state.isAdmin,
        selectedPlan: selectedPlan ?? state.selectedPlan,
        isAddLinkDuringShare:
            isAddLinkDuringShare ?? state.isAddLinkDuringShare,
        editedName: editedName ?? state.editedName,
        userAppRating: userAppRating ?? state.userAppRating,
        isPremiumUser: isPremiumUser ?? state.isPremiumUser,
      ));
    } catch (e) {}
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    return state.toMap();
  }
}
