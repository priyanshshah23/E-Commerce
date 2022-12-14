import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("##,##,##,##0.00", "en_US");
final initialZeroFormat = new NumberFormat("00.00", "en_US");
final int_oCcy = new NumberFormat("##,##,##,##0", "en_US");

class PriceUtilities {
  static String getPrice(num price) {
    return dollar +
        oCcy.format((price ?? 0).toDouble());
  }

  static String getPriceWithInitialZero(num price) {
    return initialZeroFormat.format((price ?? 0).toDouble()) +
        " " + dollar;
  }

  static String getPercent(num price) {
    return oCcy.format((price ?? 0).toDouble()) + '%';
  }

  static String getPercentWithoutPercentSign(num price) {
    return oCcy.format((price ?? 0).toDouble());
  }

  static String getIntPercent(num price) {
    return int_oCcy.format((price ?? 0).toInt()) + '%';
  }

  static String getIntPrice(num price) {
    return int_oCcy.format((price ?? 0).toInt()) +
        " " + dollar;
  }

  static String getDoubleValue(num price) {
    return (price ?? 0).toDouble().toStringAsFixed(2);
  }
}
