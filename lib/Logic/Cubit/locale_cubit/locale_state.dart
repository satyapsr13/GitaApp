part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  // enum
  final Status status;
  final String error;
  final Locale locale;
  final String localeString;
  final String localeKey;

  const LocaleState({
    this.status = Status.initial,
    this.error = "",
    this.locale = const Locale('en'),
    this.localeString = 'en',
    this.localeKey = 'en',
  });

  @override
  List<Object?> get props => [
        status,
        error,
        locale,
        localeString, localeKey
      ];

  LocaleState copyWith({
    Status? status,
    String? error,
    Locale? locale,
    String? localeString,
    String? localeKey,
  }) {
    return LocaleState(
      status: status ?? this.status,
      error: error ?? this.error,
      locale: locale ?? this.locale,
      localeKey: localeKey ?? this.localeKey,
      localeString: localeString ?? this.localeString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'error': error,
      'localeString': localeString,
      'localeKey': localeKey,
    };
  }

  factory LocaleState.fromMap(Map<String, dynamic> map) {
    return LocaleState(
      status: Status.values[map['status'] ?? 0],
      error: map['error'] ?? '',
      localeString: map['localeString'] ?? 'en',
      localeKey: map['localeKey'] ?? 'en',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocaleState.fromJson(String source) =>
      LocaleState.fromMap(json.decode(source));
}
