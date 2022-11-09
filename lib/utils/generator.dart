import 'dart:math';

class Generator {
  static String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVXAYabcdefghijklmnopqrstuvxay';

  static String generateString() {
    final random = Random();
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 20; i++) {
      int randInt = random.nextInt(50);
      buffer.write(alphabet[randInt]);
    }
    return buffer.toString();
  }
}
