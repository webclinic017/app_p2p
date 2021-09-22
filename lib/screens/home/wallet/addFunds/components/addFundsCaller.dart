

import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';

class AddFundsCaller {

  String? paymentMethod;
  BalanceData? balanceData;
  ExchangeData? exchangeData;

  void update(String method, BalanceData balanceData, ExchangeData exchangeData) {
    this.paymentMethod = method;
    this.balanceData = balanceData;
    this.exchangeData = exchangeData;
  }
}