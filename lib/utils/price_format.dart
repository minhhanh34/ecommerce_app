import 'package:intl/intl.dart';

class PriceFormat {
  static format(int price) {
    NumberFormat format = NumberFormat.simpleCurrency(locale: 'vi');
    return format.format(price);
  }
}
