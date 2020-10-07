import 'package:intl/intl.dart';

class DateUtilities {
  String getFormattedDateString(DateTime date, {String formatter}) {
    if (formatter == null) {
      formatter = kMainSourceFormat;
    }
    return DateFormat(formatter).format(date);
  }

  DateTime getDateFromString(String dateString, {String formatter}) {
    if (formatter == null) {
      formatter = kMainSourceFormat;
    }
    return DateFormat(formatter).parse(dateString);
  }

  String convertDateToFormatterString(String dateString, {String formatter}) {
    return getFormattedDateString(
      getDateFromString(dateString, formatter: formatter),
      formatter: formatter,
    );
  }

  String convertServerDateToFormatterString(String dateString,
      {String formatter}) {
    if (dateString == "" || dateString == null) return "";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            DateTime.parse(dateString).millisecondsSinceEpoch)
        .toLocal();
    return getFormattedDateString(
      getDateFromString(dateTime.toIso8601String(), formatter: kSourceFormat),
      formatter: formatter,
    );
  }

  String dayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  String getFormattedDay(DateTime date) {
    var dt = getStartOfDay(date);
    var currentDate = getStartOfDay(DateTime.now());

    final diffInDays = currentDate.difference(dt).inDays;
    if (diffInDays == 0) {
      // current day
      return "Today";
    } else if (diffInDays == 1) {
      // 1 day
      return "Yesterday";
    } else if (diffInDays >= 2 && diffInDays <= 6) {
      // same week
      return getFormattedDateString(date, formatter: eeee);
    } else {
      // more than week
      String strDate = getFormattedDateString(date, formatter: eee_dd_mmm_yyyy);
      return strDate + " at ";
    }
  }

  static const String kMainSourceFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";

  static const kSourceFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
  static const String dd_mm_yyyy_hh_mm = "dd-MM-yyyy HH:mm";
  static const String dd_mm_yyyy_hh_mm_ss_a = "dd/MM/yyyy',' hh:mm a";
  static const String dd_mm_yyyy_n_mm_ss_a = "dd/MM/yyyy'\n' hh:mm a";
  static const String dd_mm_yyyy = "dd MMM yyyy";
  static const String dd_mmm = "dd MMM";
  static const String mm_yyyy = "MM/yyyy";
  static const String dd = "d";
  static const String mmm = "MMM";
  static const String yyyy = "yyyy";
  static const String file_name_date = "dd MMM yyyy";
  static const String dd_mm_yyyy_ = "dd-MM-yyyy";
  static const String yyyy_mm_dd = "yyyy-MM-dd";

  static const String ddmmyyyy_ = "dd/MM/yyyy";
  static const String hh_mm_ss = "HH:mm:ss";
  static const String hh_mm_a = "hh:mm a";
  static const String h_mm_a = "h:mm a";
  static const String eeee = "EEEE";
  static const String eee_dd_mmm_yyyy = "EEEE, dd MMM yyyy";

  static const String dd_mmm_yy_h_mm_a = "dd MMM''yy 'at' h:mma";
}
