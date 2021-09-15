

import 'package:flutter/material.dart';

class CurrenciesColors {

  static List<String> specialColorsCode = [
    "BTC-USD.CC"
  ];

  static List<Color> specialsColors = [
    Color.fromRGBO(242, 169, 0, 1.0)
  ];

  static Color getCurrencyColor(String code) {

    if(specialColorsCode.indexOf(code) != -1) {
      return specialsColors[specialColorsCode.indexOf(code)];
    }

    String codeString = "";
    for(int c in code.codeUnits) {

      codeString += c.toString();
    }

    return Color((double.parse(codeString) * 0xFFFFFF).toInt()).withOpacity(1.0);

  }
}