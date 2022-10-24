import 'package:intl/intl.dart';

import 'package:notus/notus.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:solar_datepicker/solar_datepicker.dart';
import 'package:syncfusion_flutter_core/core.dart';

class DateUtil {
  static String formatDateFromString(Map<String, dynamic> data) {
    final String type = data['type'];

    final isGregorian = fromString(type) == DateType.gregorian;
    final isLunar = fromString(type) == DateType.lunar;

    final String format = data['format'] ?? (isGregorian ? 'yyyy-MM-dd' : 'yyyy/mm/dd');
    DateFormat formatter;
    DateTime date;
    try {
      formatter = DateFormat(format);
      date = DateTime.tryParse(data['date']);
    } catch (e) {
      return '';
    }
    if (isGregorian) {
      return formatter.format(date);
    } else if (isLunar) {
      return date.toLunar.toString();
    } else {
      return SolarDate.sDate(defualtFormat: format, gregorian: data['date']).getDate;
    }
  }

  static DateType fromString(String type) {
    switch (type) {
      case 'gregorian':
        return DateType.gregorian;
      case 'solar':
        return DateType.solar;
      case 'lunar':
        return DateType.lunar;
      default:
        return DateType.gregorian;
    }
  }
}

extension DateTypeExtension on DateType {
  DateType get(int index) {
    switch (index) {
      case 0:
        return DateType.gregorian;
      case 1:
        return DateType.solar;
      case 2:
        return DateType.lunar;
      default:
        return DateType.gregorian;
    }
  }
}

extension DateTimeExtension on DateTime {
  HijriDateTime get toLunar => convertToHijriDate(this);

  Jalali get toSolar => Jalali.fromDateTime(this);
}
