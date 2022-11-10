import 'package:intl/intl.dart';

class PriceHealper {
  static String format(int price) {
    NumberFormat format = NumberFormat.simpleCurrency(locale: 'vi');
    return format.format(price);
  }

  static int totalPrice(List<Map<String, dynamic>> order) {
    int total = 0;
    for (var prod in order) {
      total += (prod['price'] as int) * (prod['quantity'] as int);
    }
    return total;
  }
}
