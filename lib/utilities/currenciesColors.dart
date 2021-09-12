

import 'package:flutter/material.dart';

class CurrenciesColors {

  static Color getCurrencyColor(String code) {

    String codeString = "";
    for(int c in code.codeUnits) {
      codeString += c.toString();
    }

    return Color((double.parse(codeString) * 0xFFFFFF).toInt()).withOpacity(1.0);

  }
}