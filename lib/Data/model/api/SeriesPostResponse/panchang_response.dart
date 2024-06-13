import 'dart:convert';

class PanchangResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final PanditData? data;

  PanchangResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  PanchangResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    PanditData? data,
  }) =>
      PanchangResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PanchangResponse.fromJson(String str) =>
      PanchangResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PanchangResponse.fromMap(Map<String, dynamic> json) =>
      PanchangResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null ? null : PanditData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class PanditData {
  final List<String>? mainPanchang;
  final List<PanchangBg>? backgrounds;
  final PanchangContent? content;

  PanditData({
    this.mainPanchang,
    this.backgrounds,
    this.content,
  });

  PanditData copyWith({
    List<String>? mainPanchang,
    List<PanchangBg>? backgrounds,
    PanchangContent? content,
  }) =>
      PanditData(
        mainPanchang: mainPanchang ?? this.mainPanchang,
        backgrounds: backgrounds ?? this.backgrounds,
        content: content ?? this.content,
      );

  factory PanditData.fromJson(String str) => PanditData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PanditData.fromMap(Map<String, dynamic> json) => PanditData(
        mainPanchang: json["main_panchang"] == null
            ? []
            : List<String>.from(json["main_panchang"]!.map((x) => x)),
        backgrounds: json["backgrounds"] == null
            ? []
            : List<PanchangBg>.from(
                json["backgrounds"]!.map((x) => PanchangBg.fromMap(x))),
        content:
            json["content"] == null ? null : PanchangContent.fromMap(json["content"]),
      );

  Map<String, dynamic> toMap() => {
        "main_panchang": mainPanchang == null
            ? []
            : List<dynamic>.from(mainPanchang!.map((x) => x)),
        "backgrounds": backgrounds == null
            ? []
            : List<dynamic>.from(backgrounds!.map((x) => x.toMap())),
        "content": content?.toMap(),
      };
}

class PanchangBg {
  final String? image;
  final String? titleColor;
  final String? indexColor;
  final String? infoColor;

  PanchangBg({
    this.image,
    this.titleColor,
    this.indexColor,
    this.infoColor,
  });

  PanchangBg copyWith({
    String? image,
    String? titleColor,
    String? indexColor,
    String? infoColor,
  }) =>
      PanchangBg(
        image: image ?? this.image,
        titleColor: titleColor ?? this.titleColor,
        indexColor: indexColor ?? this.indexColor,
        infoColor: infoColor ?? this.infoColor,
      );

  factory PanchangBg.fromJson(String str) =>
      PanchangBg.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PanchangBg.fromMap(Map<String, dynamic> json) => PanchangBg(
        image: json["image"],
        titleColor: json["title_color"],
        indexColor: json["index_color"],
        infoColor: json["info_color"],
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "title_color": titleColor,
        "index_color": indexColor,
        "info_color": infoColor,
      };
}

class PanchangContent {
  final Risenset? risenset;
  final Panchang? panchang;
  final Lunar? lunar;
  final Rashi? rashi;
  final Rituayana? rituayana;
  final Calender? calender;
  final List<Auspicious>? auspicious;
  final List<Auspicious>? inauspicious;
  final Panchak? panchak;

  PanchangContent({
    this.risenset,
    this.panchang,
    this.lunar,
    this.rashi,
    this.rituayana,
    this.calender,
    this.auspicious,
    this.inauspicious,
    this.panchak,
  });

  PanchangContent copyWith({
    Risenset? risenset,
    Panchang? panchang,
    Lunar? lunar,
    Rashi? rashi,
    Rituayana? rituayana,
    Calender? calender,
    List<Auspicious>? auspicious,
    List<Auspicious>? inauspicious,
    Panchak? panchak,
  }) =>
      PanchangContent(
        risenset: risenset ?? this.risenset,
        panchang: panchang ?? this.panchang,
        lunar: lunar ?? this.lunar,
        rashi: rashi ?? this.rashi,
        rituayana: rituayana ?? this.rituayana,
        calender: calender ?? this.calender,
        auspicious: auspicious ?? this.auspicious,
        inauspicious: inauspicious ?? this.inauspicious,
        panchak: panchak ?? this.panchak,
      );

  factory PanchangContent.fromJson(String str) => PanchangContent.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PanchangContent.fromMap(Map<String, dynamic> json) => PanchangContent(
        risenset: json["risenset"] == null
            ? null
            : Risenset.fromMap(json["risenset"]),
        panchang: json["panchang"] == null
            ? null
            : Panchang.fromMap(json["panchang"]),
        lunar: json["lunar"] == null ? null : Lunar.fromMap(json["lunar"]),
        rashi: json["rashi"] == null ? null : Rashi.fromMap(json["rashi"]),
        rituayana: json["rituayana"] == null
            ? null
            : Rituayana.fromMap(json["rituayana"]),
        calender: json["calender"] == null
            ? null
            : Calender.fromMap(json["calender"]),
        auspicious: json["auspicious"] == null
            ? []
            : List<Auspicious>.from(
                json["auspicious"]!.map((x) => Auspicious.fromMap(x))),
        inauspicious: json["inauspicious"] == null
            ? []
            : List<Auspicious>.from(
                json["inauspicious"]!.map((x) => Auspicious.fromMap(x))),
        panchak:
            json["panchak"] == null ? null : Panchak.fromMap(json["panchak"]),
      );

  Map<String, dynamic> toMap() => {
        "risenset": risenset?.toMap(),
        "panchang": panchang?.toMap(),
        "lunar": lunar?.toMap(),
        "rashi": rashi?.toMap(),
        "rituayana": rituayana?.toMap(),
        "calender": calender?.toMap(),
        "auspicious": auspicious == null
            ? []
            : List<dynamic>.from(auspicious!.map((x) => x.toMap())),
        "inauspicious": inauspicious == null
            ? []
            : List<dynamic>.from(inauspicious!.map((x) => x.toMap())),
        "panchak": panchak?.toMap(),
      };
}

class Auspicious {
  final List<String>? en;
  final List<String>? hi;

  Auspicious({
    this.en,
    this.hi,
  });

  Auspicious copyWith({
    List<String>? en,
    List<String>? hi,
  }) =>
      Auspicious(
        en: en ?? this.en,
        hi: hi ?? this.hi,
      );

  factory Auspicious.fromJson(String str) =>
      Auspicious.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Auspicious.fromMap(Map<String, dynamic> json) => Auspicious(
        en: json["en"] == null
            ? []
            : List<String>.from(json["en"]!.map((x) => x)),
        hi: json["hi"] == null
            ? []
            : List<String>.from(json["hi"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "en": en == null ? [] : List<dynamic>.from(en!.map((x) => x)),
        "hi": hi == null ? [] : List<dynamic>.from(hi!.map((x) => x)),
      };
}

class Calender {
  final List<String>? kaliyuga;
  final List<String>? lahiriAyanamsha;
  final List<String>? kaliAhargana;
  final List<String>? rataDie;
  final List<String>? julianDate;
  final List<String>? julianDay;
  final List<String>? nationalCivilDate;
  final List<String>? modifiedJulianDay;
  final List<String>? nationalNirayanaDate;

  Calender({
    this.kaliyuga,
    this.lahiriAyanamsha,
    this.kaliAhargana,
    this.rataDie,
    this.julianDate,
    this.julianDay,
    this.nationalCivilDate,
    this.modifiedJulianDay,
    this.nationalNirayanaDate,
  });

  Calender copyWith({
    List<String>? kaliyuga,
    List<String>? lahiriAyanamsha,
    List<String>? kaliAhargana,
    List<String>? rataDie,
    List<String>? julianDate,
    List<String>? julianDay,
    List<String>? nationalCivilDate,
    List<String>? modifiedJulianDay,
    List<String>? nationalNirayanaDate,
  }) =>
      Calender(
        kaliyuga: kaliyuga ?? this.kaliyuga,
        lahiriAyanamsha: lahiriAyanamsha ?? this.lahiriAyanamsha,
        kaliAhargana: kaliAhargana ?? this.kaliAhargana,
        rataDie: rataDie ?? this.rataDie,
        julianDate: julianDate ?? this.julianDate,
        julianDay: julianDay ?? this.julianDay,
        nationalCivilDate: nationalCivilDate ?? this.nationalCivilDate,
        modifiedJulianDay: modifiedJulianDay ?? this.modifiedJulianDay,
        nationalNirayanaDate: nationalNirayanaDate ?? this.nationalNirayanaDate,
      );

  factory Calender.fromJson(String str) => Calender.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Calender.fromMap(Map<String, dynamic> json) => Calender(
        kaliyuga: json["kaliyuga"] == null
            ? []
            : List<String>.from(json["kaliyuga"]!.map((x) => x)),
        lahiriAyanamsha: json["lahiri_ayanamsha"] == null
            ? []
            : List<String>.from(json["lahiri_ayanamsha"]!.map((x) => x)),
        kaliAhargana: json["kali_ahargana"] == null
            ? []
            : List<String>.from(json["kali_ahargana"]!.map((x) => x)),
        rataDie: json["rata_die"] == null
            ? []
            : List<String>.from(json["rata_die"]!.map((x) => x)),
        julianDate: json["julian_date"] == null
            ? []
            : List<String>.from(json["julian_date"]!.map((x) => x)),
        julianDay: json["julian_day"] == null
            ? []
            : List<String>.from(json["julian_day"]!.map((x) => x)),
        nationalCivilDate: json["national_civil_date"] == null
            ? []
            : List<String>.from(json["national_civil_date"]!.map((x) => x)),
        modifiedJulianDay: json["modified_julian_day"] == null
            ? []
            : List<String>.from(json["modified_julian_day"]!.map((x) => x)),
        nationalNirayanaDate: json["national_nirayana_date"] == null
            ? []
            : List<String>.from(json["national_nirayana_date"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "kaliyuga":
            kaliyuga == null ? [] : List<dynamic>.from(kaliyuga!.map((x) => x)),
        "lahiri_ayanamsha": lahiriAyanamsha == null
            ? []
            : List<dynamic>.from(lahiriAyanamsha!.map((x) => x)),
        "kali_ahargana": kaliAhargana == null
            ? []
            : List<dynamic>.from(kaliAhargana!.map((x) => x)),
        "rata_die":
            rataDie == null ? [] : List<dynamic>.from(rataDie!.map((x) => x)),
        "julian_date": julianDate == null
            ? []
            : List<dynamic>.from(julianDate!.map((x) => x)),
        "julian_day": julianDay == null
            ? []
            : List<dynamic>.from(julianDay!.map((x) => x)),
        "national_civil_date": nationalCivilDate == null
            ? []
            : List<dynamic>.from(nationalCivilDate!.map((x) => x)),
        "modified_julian_day": modifiedJulianDay == null
            ? []
            : List<dynamic>.from(modifiedJulianDay!.map((x) => x)),
        "national_nirayana_date": nationalNirayanaDate == null
            ? []
            : List<dynamic>.from(nationalNirayanaDate!.map((x) => x)),
      };
}

class Lunar {
  final List<String>? shaka;
  final List<String>? chandramasa;
  final List<String>? vikram;
  final List<String>? gujarati;

  Lunar({
    this.shaka,
    this.chandramasa,
    this.vikram,
    this.gujarati,
  });

  Lunar copyWith({
    List<String>? shaka,
    List<String>? chandramasa,
    List<String>? vikram,
    List<String>? gujarati,
  }) =>
      Lunar(
        shaka: shaka ?? this.shaka,
        chandramasa: chandramasa ?? this.chandramasa,
        vikram: vikram ?? this.vikram,
        gujarati: gujarati ?? this.gujarati,
      );

  factory Lunar.fromJson(String str) => Lunar.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Lunar.fromMap(Map<String, dynamic> json) => Lunar(
        shaka: json["shaka"] == null
            ? []
            : List<String>.from(json["shaka"]!.map((x) => x)),
        chandramasa: json["chandramasa"] == null
            ? []
            : List<String>.from(json["chandramasa"]!.map((x) => x)),
        vikram: json["vikram"] == null
            ? []
            : List<String>.from(json["vikram"]!.map((x) => x)),
        gujarati: json["gujarati"] == null
            ? []
            : List<String>.from(json["gujarati"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "shaka": shaka == null ? [] : List<dynamic>.from(shaka!.map((x) => x)),
        "chandramasa": chandramasa == null
            ? []
            : List<dynamic>.from(chandramasa!.map((x) => x)),
        "vikram":
            vikram == null ? [] : List<dynamic>.from(vikram!.map((x) => x)),
        "gujarati":
            gujarati == null ? [] : List<dynamic>.from(gujarati!.map((x) => x)),
      };
}

class Panchak {
  final List<Auspicious>? panchakRahita;
  final List<Auspicious>? udayaLagna;

  Panchak({
    this.panchakRahita,
    this.udayaLagna,
  });

  Panchak copyWith({
    List<Auspicious>? panchakRahita,
    List<Auspicious>? udayaLagna,
  }) =>
      Panchak(
        panchakRahita: panchakRahita ?? this.panchakRahita,
        udayaLagna: udayaLagna ?? this.udayaLagna,
      );

  factory Panchak.fromJson(String str) => Panchak.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Panchak.fromMap(Map<String, dynamic> json) => Panchak(
        panchakRahita: json["panchak_rahita"] == null
            ? []
            : List<Auspicious>.from(
                json["panchak_rahita"]!.map((x) => Auspicious.fromMap(x))),
        udayaLagna: json["udaya_lagna"] == null
            ? []
            : List<Auspicious>.from(
                json["udaya_lagna"]!.map((x) => Auspicious.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "panchak_rahita": panchakRahita == null
            ? []
            : List<dynamic>.from(panchakRahita!.map((x) => x.toMap())),
        "udaya_lagna": udayaLagna == null
            ? []
            : List<dynamic>.from(udayaLagna!.map((x) => x.toMap())),
      };
}

class Panchang {
  final List<String>? tithi;
  final List<String>? yog;
  final List<String>? nakshatra;
  final List<String>? karana;
  final List<String>? day;
  final List<String>? paksha;

  Panchang({
    this.tithi,
    this.yog,
    this.nakshatra,
    this.karana,
    this.day,
    this.paksha,
  });

  Panchang copyWith({
    List<String>? tithi,
    List<String>? yog,
    List<String>? nakshatra,
    List<String>? karana,
    List<String>? day,
    List<String>? paksha,
  }) =>
      Panchang(
        tithi: tithi ?? this.tithi,
        yog: yog ?? this.yog,
        nakshatra: nakshatra ?? this.nakshatra,
        karana: karana ?? this.karana,
        day: day ?? this.day,
        paksha: paksha ?? this.paksha,
      );

  factory Panchang.fromJson(String str) => Panchang.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Panchang.fromMap(Map<String, dynamic> json) => Panchang(
        tithi: json["tithi"] == null
            ? []
            : List<String>.from(json["tithi"]!.map((x) => x)),
        yog: json["yog"] == null
            ? []
            : List<String>.from(json["yog"]!.map((x) => x)),
        nakshatra: json["nakshatra"] == null
            ? []
            : List<String>.from(json["nakshatra"]!.map((x) => x)),
        karana: json["karana"] == null
            ? []
            : List<String>.from(json["karana"]!.map((x) => x)),
        day: json["day"] == null
            ? []
            : List<String>.from(json["day"]!.map((x) => x)),
        paksha: json["paksha"] == null
            ? []
            : List<String>.from(json["paksha"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "tithi": tithi == null ? [] : List<dynamic>.from(tithi!.map((x) => x)),
        "yog": yog == null ? [] : List<dynamic>.from(yog!.map((x) => x)),
        "nakshatra": nakshatra == null
            ? []
            : List<dynamic>.from(nakshatra!.map((x) => x)),
        "karana":
            karana == null ? [] : List<dynamic>.from(karana!.map((x) => x)),
        "day": day == null ? [] : List<dynamic>.from(day!.map((x) => x)),
        "paksha":
            paksha == null ? [] : List<dynamic>.from(paksha!.map((x) => x)),
      };
}

class Rashi {
  final List<String>? moonsign;
  final List<String>? sunsign;
  final List<String>? sunNakshatra;
  final List<String>? sunNakshatraPada;
  final List<String>? nakshatraPada;

  Rashi({
    this.moonsign,
    this.sunsign,
    this.sunNakshatra,
    this.sunNakshatraPada,
    this.nakshatraPada,
  });

  Rashi copyWith({
    List<String>? moonsign,
    List<String>? sunsign,
    List<String>? sunNakshatra,
    List<String>? sunNakshatraPada,
    List<String>? nakshatraPada,
  }) =>
      Rashi(
        moonsign: moonsign ?? this.moonsign,
        sunsign: sunsign ?? this.sunsign,
        sunNakshatra: sunNakshatra ?? this.sunNakshatra,
        sunNakshatraPada: sunNakshatraPada ?? this.sunNakshatraPada,
        nakshatraPada: nakshatraPada ?? this.nakshatraPada,
      );

  factory Rashi.fromJson(String str) => Rashi.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rashi.fromMap(Map<String, dynamic> json) => Rashi(
        moonsign: json["moonsign"] == null
            ? []
            : List<String>.from(json["moonsign"]!.map((x) => x)),
        sunsign: json["sunsign"] == null
            ? []
            : List<String>.from(json["sunsign"]!.map((x) => x)),
        sunNakshatra: json["sun_nakshatra"] == null
            ? []
            : List<String>.from(json["sun_nakshatra"]!.map((x) => x)),
        sunNakshatraPada: json["sun_nakshatra_pada"] == null
            ? []
            : List<String>.from(json["sun_nakshatra_pada"]!.map((x) => x)),
        nakshatraPada: json["nakshatra_pada"] == null
            ? []
            : List<String>.from(json["nakshatra_pada"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "moonsign":
            moonsign == null ? [] : List<dynamic>.from(moonsign!.map((x) => x)),
        "sunsign":
            sunsign == null ? [] : List<dynamic>.from(sunsign!.map((x) => x)),
        "sun_nakshatra": sunNakshatra == null
            ? []
            : List<dynamic>.from(sunNakshatra!.map((x) => x)),
        "sun_nakshatra_pada": sunNakshatraPada == null
            ? []
            : List<dynamic>.from(sunNakshatraPada!.map((x) => x)),
        "nakshatra_pada": nakshatraPada == null
            ? []
            : List<dynamic>.from(nakshatraPada!.map((x) => x)),
      };
}

class Risenset {
  final List<String>? sunrise;
  final List<String>? sunset;
  final List<String>? moonrise;
  final List<String>? moonset;

  Risenset({
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
  });

  Risenset copyWith({
    List<String>? sunrise,
    List<String>? sunset,
    List<String>? moonrise,
    List<String>? moonset,
  }) =>
      Risenset(
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        moonrise: moonrise ?? this.moonrise,
        moonset: moonset ?? this.moonset,
      );

  factory Risenset.fromJson(String str) => Risenset.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Risenset.fromMap(Map<String, dynamic> json) => Risenset(
        sunrise: json["sunrise"] == null
            ? []
            : List<String>.from(json["sunrise"]!.map((x) => x)),
        sunset: json["sunset"] == null
            ? []
            : List<String>.from(json["sunset"]!.map((x) => x)),
        moonrise: json["moonrise"] == null
            ? []
            : List<String>.from(json["moonrise"]!.map((x) => x)),
        moonset: json["moonset"] == null
            ? []
            : List<String>.from(json["moonset"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "sunrise":
            sunrise == null ? [] : List<dynamic>.from(sunrise!.map((x) => x)),
        "sunset":
            sunset == null ? [] : List<dynamic>.from(sunset!.map((x) => x)),
        "moonrise":
            moonrise == null ? [] : List<dynamic>.from(moonrise!.map((x) => x)),
        "moonset":
            moonset == null ? [] : List<dynamic>.from(moonset!.map((x) => x)),
      };
}

class Rituayana {
  final List<String>? drikRitu;
  final List<String>? dinamana;
  final List<String>? vedicRitu;
  final List<String>? ratrimana;
  final List<String>? drikAyana;
  final List<String>? madhyahna;
  final List<String>? vedicAyana;

  Rituayana({
    this.drikRitu,
    this.dinamana,
    this.vedicRitu,
    this.ratrimana,
    this.drikAyana,
    this.madhyahna,
    this.vedicAyana,
  });

  Rituayana copyWith({
    List<String>? drikRitu,
    List<String>? dinamana,
    List<String>? vedicRitu,
    List<String>? ratrimana,
    List<String>? drikAyana,
    List<String>? madhyahna,
    List<String>? vedicAyana,
  }) =>
      Rituayana(
        drikRitu: drikRitu ?? this.drikRitu,
        dinamana: dinamana ?? this.dinamana,
        vedicRitu: vedicRitu ?? this.vedicRitu,
        ratrimana: ratrimana ?? this.ratrimana,
        drikAyana: drikAyana ?? this.drikAyana,
        madhyahna: madhyahna ?? this.madhyahna,
        vedicAyana: vedicAyana ?? this.vedicAyana,
      );

  factory Rituayana.fromJson(String str) => Rituayana.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rituayana.fromMap(Map<String, dynamic> json) => Rituayana(
        drikRitu: json["drik_ritu"] == null
            ? []
            : List<String>.from(json["drik_ritu"]!.map((x) => x)),
        dinamana: json["dinamana"] == null
            ? []
            : List<String>.from(json["dinamana"]!.map((x) => x)),
        vedicRitu: json["vedic_ritu"] == null
            ? []
            : List<String>.from(json["vedic_ritu"]!.map((x) => x)),
        ratrimana: json["ratrimana"] == null
            ? []
            : List<String>.from(json["ratrimana"]!.map((x) => x)),
        drikAyana: json["drik_ayana"] == null
            ? []
            : List<String>.from(json["drik_ayana"]!.map((x) => x)),
        madhyahna: json["madhyahna"] == null
            ? []
            : List<String>.from(json["madhyahna"]!.map((x) => x)),
        vedicAyana: json["vedic_ayana"] == null
            ? []
            : List<String>.from(json["vedic_ayana"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "drik_ritu":
            drikRitu == null ? [] : List<dynamic>.from(drikRitu!.map((x) => x)),
        "dinamana":
            dinamana == null ? [] : List<dynamic>.from(dinamana!.map((x) => x)),
        "vedic_ritu": vedicRitu == null
            ? []
            : List<dynamic>.from(vedicRitu!.map((x) => x)),
        "ratrimana": ratrimana == null
            ? []
            : List<dynamic>.from(ratrimana!.map((x) => x)),
        "drik_ayana": drikAyana == null
            ? []
            : List<dynamic>.from(drikAyana!.map((x) => x)),
        "madhyahna": madhyahna == null
            ? []
            : List<dynamic>.from(madhyahna!.map((x) => x)),
        "vedic_ayana": vedicAyana == null
            ? []
            : List<dynamic>.from(vedicAyana!.map((x) => x)),
      };
}
