// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalizationAssetLoader extends AssetLoader {
  final Map<String, dynamic> minRequiredTranslations = {
    "app_title": "Todo App",
    "edit_page_title": "Edit Todo",
    "add_page_title": "Add Todo"
  };

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final appSupportDirectory = await getApplicationSupportDirectory();
    final directory = await appSupportDirectory.create();
    final path = directory.absolute.path;
    String translationsRes;

    switch (locale.languageCode) {
      case 'en':
        File jsonFile = File('$path/en.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
      case 'ja':
        File jsonFile = File('$path/ja.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
      default:
        File jsonFile = File('$path/en.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
    }
  }
}
