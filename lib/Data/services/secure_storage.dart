import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/ObjectModels/saved_post_model.dart';
import '../model/ObjectModels/user.model.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() =>
      _instance ??= SecureStorage._(const FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _phoneKey = 'PHONE';
  static const _localeKey = 'LANG';
  static const _firstNameKey = 'LANG';
  static const _lastNameKey = 'LANG';
  static const _userModelKey = 'USER_MODEL';
  static const localPhotoPathKey = 'PHOTO_URL';
  static const userProfileImageListKey = 'User_Profile_ImageList';
  static const sharedPostListKey = 'sharedList';
  static const occupationKey = 'Occupation';
  static const showOccupationKey = 'SHOW_OCCUPATION';

  Future<void> persistPhoneAndToken(String phone, String token) async {
    await _storage.write(key: _phoneKey, value: phone);
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> storeLocally(
      {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> saveTokeInDB(String value) async {
    await _storage.write(key: _tokenKey, value: value);
  }

  Future<void> deleteFromLocalStorage(String keyValue) async {
    await _storage.delete(key: keyValue);
  }

  Future<String> readLocally(String key) async {
    return await _storage.read(key: key) ?? "";
  }

  Future<void> persistLocale(String locale) async {
    await _storage.write(key: _localeKey, value: locale);
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: _tokenKey);
    return value != null;
  }

  Future<UserModel?> getUserModel() async {
    String? userJson = await _storage.read(key: _userModelKey);

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap.toString());
    } else {
      return null;
    }
  }

  Future<bool> saveUserModel(UserModel userModel) async {
    try {
      String userJson = jsonEncode(userModel.toJson());
      await _storage.write(key: _userModelKey, value: userJson);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasPhone() async {
    var value = _storage.read(key: _phoneKey);
    return value != null;
  }

  Future<void> savePostList(int id, String imageUrl) async {
    String? list = await _storage.read(key: "sharedList");
    if (list != null) {
      try {
        SavedPostList savedPostList = SavedPostList.fromJson(jsonDecode(list));
        List<SavedPost> newPost = savedPostList.savedPostList;
        if (!newPost.any((element) => element.postId == id)) {
          newPost.add(SavedPost(postId: id, imageLink: imageUrl));
        }

        final SavedPostList savedPostList1 =
            SavedPostList(savedPostList: newPost);
        await _storage.delete(key: "sharedList");

        await _storage.write(
            key: "sharedList", value: jsonEncode(savedPostList1));
      } catch (e) {}
    } else {
      // print("********idList start5**********");
      List<SavedPost> newPost = [];
      newPost.add(SavedPost(postId: id, imageLink: imageUrl));
      final SavedPostList savedPostList = SavedPostList(savedPostList: newPost);
      try {
        await _storage.write(
            key: "sharedList", value: jsonEncode(savedPostList));
      } catch (e) {
        // print("*******Error in saving post in local storage -> $e******");
      }
    }
  }

  Future<void> saveSharedPhotosList(List<SavedPost> profilePhotos) async {
    final List<Map<String, dynamic>> profilePhotosMapList =
        profilePhotos.map((photo) => photo.toMap()).toList();
    final String jsonString = jsonEncode(profilePhotosMapList);
    await _storage.write(key: sharedPostListKey, value: jsonString);
  }

  Future<List<SavedPost>> getSharedPhotosList() async {
    final String? jsonString = await _storage.read(key: sharedPostListKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decodedList = jsonDecode(jsonString);
    final List<SavedPost> profilePhotos =
        decodedList.map((item) => SavedPost.fromMap(item)).toList();

    return profilePhotos;
  }

  Future<void> saveProfilePhotos(List<ProfilePhotos> profilePhotos) async {
    final List<Map<String, dynamic>> profilePhotosMapList =
        profilePhotos.map((photo) => photo.toMap()).toList();
    final String jsonString = jsonEncode(profilePhotosMapList);
    await _storage.write(key: userProfileImageListKey, value: jsonString);
  }

  Future<List<ProfilePhotos>> getProfilePhotos() async {
    final String? jsonString =
        await _storage.read(key: userProfileImageListKey);

    if (jsonString == null) {
      // Return an empty list if no data is stored yet
      return [];
    }

    final List<dynamic> decodedList = jsonDecode(jsonString);
    final List<ProfilePhotos> profilePhotos =
        decodedList.map((item) => ProfilePhotos.fromMap(item)).toList();

    return profilePhotos;
  }

  Future<List<SavedPost>> getPostList() async {
    String? list = await _storage.read(key: "sharedList");
    if (list != null) {
      SavedPostList savedPostList = SavedPostList.fromJson(jsonDecode(list));
      List<SavedPost> newPost = savedPostList.savedPostList;

      return newPost;
    } else {
      return [];
    }
    // idList.add(id);
    // return idList;
    // await _storage.write(key: "sharedList", value: json.encode(idList));
  }

  Future<bool> hasLocale() async {
    var value = _storage.read(key: _localeKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> deletePhone() async {
    return _storage.delete(key: _phoneKey);
  }

  Future<void> deleteLocale() async {
    return _storage.delete(key: _localeKey);
  }

  Future<String?> getPhone() async {
    return _storage.read(key: _phoneKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<int> getCoins() async {
    return int.parse(await _storage.read(key: "COINS") ?? 0.toString());
  }

  Future<void> saveCoins(int coins) async {
    //  int.parse(await _storage.read(key: "COINS") ?? 0.toString());
    await _storage.write(key: "COINS", value: coins.toString());
  }

  Future<String?> getLocale() async {
    return await _storage.read(key: _localeKey);
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }

  Future<String?> getFirstName() async {
    return await _storage.read(key: "NAME");
  }

  Future<String?> getNumber() async {
    return await _storage.read(key: "NUMBER");
  }

  Future<String?> getOccupation() async {
    return await _storage.read(key: "OCCUPATION");
  }

  Future<String?> getLastName() async {
    return await _storage.read(key: "LAST_NAME");
  }

  Future<String?> getNameShowStatus() async {
    return await _storage.read(key: "SHOW_NAME");
  }

  Future<String?> getNumberShowStatus() async {
    return await _storage.read(key: "SHOW_NUMBER");
  }

  Future<String?> getOccupationShowStatus() async {
    return await _storage.read(key: showOccupationKey);
  }

  Future<String?> getProfileShowStatus() async {
    return await _storage.read(key: "SHOW_PROFILE");
  }

  Future<void> deleteProfileShowStatus() async {
    return await _storage.delete(key: "SHOW_PROFILE");
  }

  Future<void> deleteNameShowStatus() async {
    return await _storage.delete(key: "SHOW_NAME");
  }

  Future<String?> getPhotoLocation() async {
    return await _storage.read(key: "PHOTO_URL");
  }
}
