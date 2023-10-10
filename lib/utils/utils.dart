import 'package:flutter/widgets.dart';

class Utils{
    static String trim(double number){
        if (number == number.toInt().toDouble()) {
            return number.toInt().toString();
        } else {
            return number.toString();
        }
    }

    static double calculateFontSize(BuildContext context, String text) {
      double screenWidth = MediaQuery.of(context).size.width;
      double targetWidth = screenWidth * 0.8 / (text.length); // 80% of the screen width
      return targetWidth; // You can adjust this factor to control the font size
    }

}