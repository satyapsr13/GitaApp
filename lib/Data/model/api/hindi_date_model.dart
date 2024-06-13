import 'dart:convert';

class HindiDate {
  final int? id;
  final String? date;
  final String? month;
  final String? tithi;
  final String? paksha;

  HindiDate({
    this.id,
    this.date,
    this.month,
    this.tithi,
    this.paksha,
  });

  factory HindiDate.fromMap(Map<String, dynamic> json) => HindiDate(
        id: json["id"],
        date: json["date"],
        month: json["month"],
        tithi: json["tithi"],
        paksha: json["paksha"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'month': month,
      'tithi': tithi,
      'paksha': paksha,
    };
  }

  String toJson() => json.encode(toMap());

  factory HindiDate.fromJson(String source) =>
      HindiDate.fromMap(json.decode(source));
}
