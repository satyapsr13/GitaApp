import 'package:flutter/material.dart';

import '../../../../Data/model/api/SeriesPostResponse/panchang_response.dart';
import '../../../../Utility/common.dart';

String getSuryodayaText(PanditData data, int index) {
  Risenset? risenset = data.content?.risenset;
  Panchang? panchang = data.content?.panchang;
  Lunar? lunar = data.content?.lunar;
  switch (index) {
    case 1:
      return "--   सूर्योदय एवं चन्द्रोदय 🌄  -- \nसूर्योदय ${risenset?.sunrise?.first} \nचन्द्रोदय ${risenset?.moonrise?.first}\nसूर्यास्त ${risenset?.sunset?.first}\nचन्द्रास्त ${risenset?.moonset?.first}\n\n--   पञ्चाङ्ग   --\nतिथि ${panchang?.tithi?.first}\nयोग ${panchang?.yog?.first}\nवार ${panchang?.day?.first}\nपक्ष ${panchang?.paksha?.first}\nनक्षत्र ${panchang?.nakshatra?.first}\nकरण ${panchang?.karana?.first} ";
    case 2:
      return "--   चन्द्र मास एवं सम्वत   --\nशक सम्वत ${data.content?.lunar?.shaka?.first}\nविक्रम सम्वत ${data.content?.lunar?.vikram?.first}\nगुजराती सम्वत ${data.content?.lunar?.gujarati?.first}\nचन्द्रमास ${data.content?.lunar?.chandramasa?.first}\n\n--   राशि तथा नक्षत्र   --\nचन्द्र राशि ${data.content?.rashi?.moonsign?.first}\nसूर्य राशि ${data.content?.rashi?.sunsign?.first}\nसूर्य नक्षत्र ${data.content?.rashi?.sunNakshatra?.first}\nसूर्य नक्षत्र पद ${data.content?.rashi?.sunNakshatraPada?.first}\nनक्षत्र पद ${data.content?.rashi?.nakshatraPada?.first}\n";
    case 3:
      return "--   ऋतु और अयन   --\nद्रिक ऋतु ${data.content?.rituayana?.drikRitu?.first}\nवैदिक ऋतु ${data.content?.rituayana?.vedicRitu?.first}\nद्रिक अयन ${data.content?.rituayana?.drikAyana?.first}\nवैदिक अयन ${data.content?.rituayana?.vedicAyana?.first}\nदिनमान ${data.content?.rituayana?.dinamana?.first}\nरात्रिमान ${data.content?.rituayana?.ratrimana?.first}\nमध्याह्न ${data.content?.rituayana?.madhyahna?.first}\n";
    case 4:
      return "--   अन्य कैलेंडर   --\nकलियुग ${data.content?.calender?.kaliyuga?.first}\nकलि अहर्गण ${data.content?.calender?.kaliAhargana?.first}\nजूलियन दिनाङ्क ${data.content?.calender?.julianDate?.first}\nराष्ट्रीय नागरिक दिनाङ्क ${data.content?.calender?.nationalCivilDate?.first}\nराष्ट्रीय निरयण दिनाङ्क ${data.content?.calender?.nationalNirayanaDate?.first}\nलाहिरी अयनांश ${data.content?.calender?.lahiriAyanamsha?.first}\nराटा डाई ${data.content?.calender?.rataDie?.first}\nजूलियन दिन ${data.content?.calender?.julianDay?.first}\nसंशोधित जूलियन दिन ${data.content?.calender?.modifiedJulianDay?.first}\n";
    case 5:
      return "--   शुभ समय   --\n${data.content?.auspicious?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 6:
      return "--   अशुभ समय   --\n${data.content?.inauspicious?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 7:
      return "--   पंचक रहित   --\n${data.content?.panchak?.panchakRahita?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 8:
      return "--   उदय लग्न   --\n${data.content?.panchak?.udayaLagna?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";

    default:
      return "";
  }
}

String getSuryodayaTextForCopy(PanditData data, int index) {
  Risenset? risenset = data.content?.risenset;
  Panchang? panchang = data.content?.panchang;
  Lunar? lunar = data.content?.lunar;
  switch (index) {
    case 1:
      return "-- 🌄  सूर्योदय एवं चन्द्रोदय 🌄  -- \nसूर्योदय - ${risenset?.sunrise?.first} \nचन्द्रोदय - ${risenset?.moonrise?.first}\nसूर्यास्त - ${risenset?.sunset?.first}\nचन्द्रास्त - ${risenset?.moonset?.first}\n\n--   पञ्चाङ्ग   --\nतिथि - ${panchang?.tithi?.first}\nयोग - ${panchang?.yog?.first}\nवार - ${panchang?.day?.first}\nपक्ष - ${panchang?.paksha?.first}\nनक्षत्र - ${panchang?.nakshatra?.first}\nकरण - ${panchang?.karana?.first} ";
    case 2:
      return "--  🌙 चन्द्र मास एवं सम्वत 🌙  --\nशक सम्वत - ${data.content?.lunar?.shaka?.first}\nविक्रम सम्वत - ${data.content?.lunar?.vikram?.first}\nगुजराती सम्वत - ${data.content?.lunar?.gujarati?.first}\nचन्द्रमास - ${data.content?.lunar?.chandramasa?.first}\n\n--   राशि तथा नक्षत्र   --\nचन्द्र राशि - ${data.content?.rashi?.moonsign?.first}\nसूर्य राशि - ${data.content?.rashi?.sunsign?.first}\nसूर्य नक्षत्र - ${data.content?.rashi?.sunNakshatra?.first}\nसूर्य नक्षत्र पद - ${data.content?.rashi?.sunNakshatraPada?.first}\nनक्षत्र पद - ${data.content?.rashi?.nakshatraPada?.first}\n";
    case 3:
      return "--   ऋतु और अयन   --\nद्रिक ऋतु - ${data.content?.rituayana?.drikRitu?.first}\nवैदिक ऋतु - ${data.content?.rituayana?.vedicRitu?.first}\nद्रिक अयन - ${data.content?.rituayana?.drikAyana?.first}\nवैदिक अयन - ${data.content?.rituayana?.vedicAyana?.first}\nदिनमान - ${data.content?.rituayana?.dinamana?.first}\nरात्रिमान - ${data.content?.rituayana?.ratrimana?.first}\nमध्याह्न - ${data.content?.rituayana?.madhyahna?.first}\n";
    case 4:
      return "--   अन्य कैलेंडर   --\nकलियुग - ${data.content?.calender?.kaliyuga?.first}\nकलि अहर्गण - ${data.content?.calender?.kaliAhargana?.first}\nजूलियन दिनाङ्क - ${data.content?.calender?.julianDate?.first}\nराष्ट्रीय नागरिक दिनाङ्क - ${data.content?.calender?.nationalCivilDate?.first}\nराष्ट्रीय निरयण दिनाङ्क - ${data.content?.calender?.nationalNirayanaDate?.first}\nलाहिरी अयनांश - ${data.content?.calender?.lahiriAyanamsha?.first}\nराटा डाई - ${data.content?.calender?.rataDie?.first}\nजूलियन दिन - ${data.content?.calender?.julianDay?.first}\nसंशोधित जूलियन दिन - ${data.content?.calender?.modifiedJulianDay?.first}\n";
    case 5:
      return "--   शुभ समय   --\n${data.content?.auspicious?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 6:
      return "--   अशुभ समय   --\n${data.content?.inauspicious?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 7:
      return "--   पंचक रहित   --\n${data.content?.panchak?.panchakRahita?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";
    case 8:
      return "--   उदय लग्न   --\n${data.content?.panchak?.udayaLagna?.map((item) => '${item.hi![0]} - ${item.hi![1]}').join('\n') ?? ''}\n";

    default:
      return "";
  }
}

class PanchangSurvodayaWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangSurvodayaWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          '--   सूर्योदय एवं चन्द्रोदय   --',
          textScaleFactor: 1,
          style: TextStyle(
            color: hexToColor(bgImage.indexColor ?? ""),
            fontSize: mq.width * 0.033,
            fontWeight: FontWeight.bold,
          ),
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'सूर्योदय',
          info: data.content?.risenset?.sunrise?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'चन्द्रोदय',
          info: data.content?.risenset?.moonrise?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'सूर्यास्त',
          info: data.content?.risenset?.sunset?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'चन्द्रास्त',
          info: data.content?.risenset?.moonset?.first,
        ),
        const SizedBox(height: 15),
        Text(
          '--   पञ्चाङ्ग   --',
          style: TextStyle(
            color: hexToColor(bgImage.indexColor ?? ""),
            fontSize: mq.width * 0.033,
            fontWeight: FontWeight.bold,
          ),
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'तिथि',
          leftPadding: 3,
          info: data.content?.panchang?.tithi?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'योग',
          leftPadding: 3,
          info: data.content?.panchang?.yog?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'वार',
          leftPadding: 3,
          info: data.content?.panchang?.day?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'पक्ष',
          info: data.content?.panchang?.paksha?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'नक्षत्र',
          leftPadding: 3,
          info: data.content?.panchang?.nakshatra?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'करण',
          info: data.content?.panchang?.karana?.first,
        ),
      ],
    );
  }
}

class PanchangChandraMasWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangChandraMasWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          '--   चन्द्र मास एवं सम्वत   --',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: hexToColor(bgImage.indexColor ?? ""),
            fontSize: mq.width * 0.033,
          ),
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'शक सम्वत',
          leftPadding: 3,
          info: data.content?.lunar?.shaka?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'विक्रम सम्वत',
          leftPadding: 3,
          info: data.content?.lunar?.vikram?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'गुजराती सम्वत',
          leftPadding: 3,
          info: data.content?.lunar?.gujarati?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'चन्द्रमास',
          leftPadding: 3,
          info: data.content?.lunar?.chandramasa?.first,
        ),
        const SizedBox(height: 15),
        Text(
          '--   राशि तथा नक्षत्र   --',
          style: TextStyle(
            color: hexToColor(bgImage.indexColor ?? ""),
            fontSize: mq.width * 0.033,
            fontWeight: FontWeight.bold,
          ),
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'चन्द्र राशि',
          leftPadding: 3,
          info: data.content?.rashi?.moonsign?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'सूर्य राशि',
          leftPadding: 3,
          info: data.content?.rashi?.sunsign?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'सूर्य नक्षत्र',
          leftPadding: 3,
          info: data.content?.rashi?.sunNakshatra?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'सूर्य नक्षत्र पद',
          leftPadding: 3,
          info: data.content?.rashi?.sunNakshatraPada?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'नक्षत्र पद',
          leftPadding: 3,
          info: data.content?.rashi?.nakshatraPada?.first,
        ),
      ],
    );
  }
}

class PanchangRituAyanWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangRituAyanWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 18;
    return Column(
      children: [
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'द्रिक ऋतु',
          leftPadding: 3,
          info: data.content?.rituayana?.drikRitu?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'वैदिक ऋतु',
          leftPadding: 3,
          info: data.content?.rituayana?.vedicRitu?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          leftPadding: 3,
          title: 'द्रिक अयन',
          info: data.content?.rituayana?.drikAyana?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'वैदिक अयन',
          leftPadding: 3,
          info: data.content?.rituayana?.vedicAyana?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          founsize: fontsize,
          leftPadding: 3,
          title: 'दिनमान',
          info: data.content?.rituayana?.dinamana?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          founsize: fontsize,
          title: 'रात्रिमान',
          leftPadding: 3,
          info: data.content?.rituayana?.ratrimana?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          title: 'मध्याह्न',
          founsize: fontsize,
          leftPadding: 3,
          info: data.content?.rituayana?.madhyahna?.first,
        ),
      ],
    );
  }
}

class PanchangAnyaCalenderWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangAnyaCalenderWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 16;
    int infoFlext = 5;
    int titleFlext = 5;
    return Column(
      children: [
        PanchangContentWidget(
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          bgImage: bgImage,
          data: data,
          title: 'कलियुग',
          info: data.content?.calender?.kaliyuga?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          bgImage: bgImage,
          data: data,
          title: 'कलि अहर्गण',
          info: data.content?.calender?.kaliAhargana?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          bgImage: bgImage,
          data: data,
          title: 'जूलियन दिनाङ्क',
          info: data.content?.calender?.julianDate?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          bgImage: bgImage,
          data: data,
          title: 'राष्ट्रीय नागरिक दिनाङ्क',
          info: data.content?.calender?.nationalCivilDate?.first,
          founsize: fontsize,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          data: data,
          founsize: fontsize,
          title: 'राष्ट्रीय निरयण दिनाङ्क',
          info: data.content?.calender?.nationalNirayanaDate?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          data: data,
          founsize: fontsize,
          title: 'लाहिरी अयनांश',
          info: data.content?.calender?.lahiriAyanamsha?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          data: data,
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          title: 'राटा डाई',
          founsize: fontsize,
          info: data.content?.calender?.rataDie?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          data: data,
          title: 'जूलियन दिन',
          founsize: fontsize,
          info: data.content?.calender?.julianDay?.first,
        ),
        PanchangContentWidget(
          bgImage: bgImage,
          infoFlex: infoFlext,
          titleFlex: titleFlext,
          data: data,
          // leftPadding: 3,
          title: 'संशोधित जूलियन दिन',
          founsize: fontsize,
          info: data.content?.calender?.modifiedJulianDay?.first,
        ),
      ],
    );
  }
}

class PanchangShubhSamayWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangShubhSamayWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 14;
    int infoFlext = 6;
    int titleFlext = 4;
    return Column(
      children: [
        ...List.generate(data.content?.auspicious?.length ?? 0, (index) {
          return PanchangContentWidget(
            infoFlex: infoFlext,
            titleFlex: titleFlext,
            leftPadding: 3,
            bgImage: bgImage,
            data: data,
            title: data.content?.auspicious?[index].hi![0],
            info: data.content?.auspicious?[index].hi![1],
            founsize: fontsize,
          );
        }),
      ],
    );
  }
}

class PanchangAshubhSamayWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangAshubhSamayWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 16;
    int infoFlext = 7;
    int titleFlext = 4;
    return Column(
      children: [
        ...List.generate(data.content?.inauspicious?.length ?? 0, (index) {
          return PanchangContentWidget(
            infoFlex: infoFlext,
            titleFlex: titleFlext,
            bgImage: bgImage,
            leftPadding: 3,
            data: data,
            title: data.content?.inauspicious?[index].hi![0],
            info: data.content?.inauspicious?[index].hi![1],
            founsize: fontsize,
          );
        }),
      ],
    );
  }
}

class PanchangPanchakRahitWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangPanchakRahitWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 12;
    int infoFlext = 7;
    int titleFlext = 4;
    return Column(
      children: [
        ...List.generate(data.content?.panchak?.panchakRahita?.length ?? 0,
            (index) {
          return PanchangContentWidget(
            infoFlex: infoFlext,
            titleFlex: titleFlext,
            bgImage: bgImage,
            leftPadding: 3,
            data: data,
            title: data.content?.panchak?.panchakRahita?[index].hi![0],
            info: data.content?.panchak?.panchakRahita?[index].hi![1],
            founsize: fontsize,
          );
        }),
      ],
    );
  }
}

class PanchangUdaylagnWidget extends StatelessWidget {
  // const PanchangSurvodayaWidget({super.key});
  final PanchangBg bgImage;
  final PanditData data;
  const PanchangUdaylagnWidget({
    Key? key,
    required this.bgImage,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontsize = 13;
    int infoFlext = 6;
    int titleFlext = 2;
    return Column(
      children: [
        ...List.generate(data.content?.panchak?.udayaLagna?.length ?? 0,
            (index) {
          return PanchangContentWidget(
            infoFlex: infoFlext,
            titleFlex: titleFlext,
            bgImage: bgImage,
            data: data,
            leftPadding: 3,
            title: data.content?.panchak?.udayaLagna?[index].hi![0],
            info: data.content?.panchak?.udayaLagna?[index].hi![1],
            founsize: fontsize,
          );
        }),
      ],
    );
  }
}

class PanchangContentWidget extends StatelessWidget {
  const PanchangContentWidget({
    Key? key,
    required this.bgImage,
    required this.data,
    this.title,
    this.founsize = 15,
    this.info,
    this.titleFlex = 2,
    this.leftPadding = 2,
    this.infoFlex = 5,
  }) : super(key: key);

  final PanchangBg bgImage;
  final PanditData data;
  final String? title;
  final String? info;
  final double founsize;
  final int leftPadding;
  final int titleFlex;
  final int infoFlex;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftPadding, child: SizedBox()),
        Expanded(
          flex: titleFlex,
          child: Text(
            (title ?? ""),
            textScaleFactor: 1,
            style: TextStyle(
                color: hexToColor(bgImage.indexColor ?? ""),
                fontSize: true ? mq.width * 0.03 : founsize,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: infoFlex,
          child: Text(
            info ?? "",
            textScaleFactor: 1,
            style: TextStyle(
              color: hexToColor(bgImage.infoColor ?? ""),
              fontSize: true ? mq.width * 0.03 : founsize,
            ),
          ),
        ),
      ],
    );
  }
}
