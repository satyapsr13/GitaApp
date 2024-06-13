import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../Constants/enums.dart';
import '../../../Data/repositories/localization.dart'; 
part 'locale_state.dart';

class LocaleCubit extends HydratedCubit<LocaleState> {
  final LocaleRepository localeRepository;
  LocaleCubit({required this.localeRepository}) : super(const LocaleState());

  void updateLocale(Locale locale) {
    emit(state.copyWith(status: Status.loading));
    String localeStringValue = locale.languageCode +
        (locale.countryCode != null ? '_${locale.countryCode}' : '');
    // print("------$localeStringValue-----------");
    emit(state.copyWith(
        locale: locale,
        localeString: localeStringValue,
        status: Status.success));
  }

  void updateLocaleKey({required String localeKey}) {
    emit(state.copyWith(localeKey: localeKey));
  }

  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    return LocaleState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) {
    return state.toMap();
  }
}
