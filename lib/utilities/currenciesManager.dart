
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/currencyData.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:dio/dio.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CurrenciesManager {


  static List<CurrencyData> getFiatCurrencies() {

    List<CurrencyData> currencies = [];
    for(int i = 0; i < fiatCurrenciesCodes.length; i ++) {
      CurrencyData currencyData = CurrencyData(name: fiatCurrenciesNames[i], code:  fiatCurrenciesCodes[i]);
      currencies.add(currencyData);
    }

    return currencies;

  }

  static List<CurrencyData> getCryptocurrencies() {
    List<CurrencyData> currencies = [];
    for(int i = 0; i < cryptocurrenciesCodes.length; i ++) {
      CurrencyData currencyData = CurrencyData(name: cryptocurrenciesNames[i], code:  cryptocurrenciesCodes[i]);
      currencies.add(currencyData);
    }

    return currencies;
  }


  static List<CurrencyData> getAssets() {
    List<CurrencyData> currencies = [];
    for(int i = 0; i < assetsCodes.length; i ++) {
      CurrencyData currencyData = CurrencyData(name: assetsNames[i], code:  assetsCodes[i]);
      currencies.add(currencyData);
    }

    return currencies;
  }




  static Widget getFlag(String code) {

    if(fiatCurrenciesCodes.indexOf(code) != -1) {
      return flags[fiatCurrenciesCodes.indexOf(code)];
    }else {
      return Container();
    }

  }




  static List<String> fiatCurrenciesCodes = [
    "USD.FOREX", "EUR.FOREX", "RUB.FOREX", "GBP.FOREX",
    "CNY.FOREX", "JPY.FOREX", "SGD.FOREX", "INR.FOREX", "CHF.FOREX",
    "AUD.FOREX", "CAD.FOREX", "HKD.FOREX", "MYR.FOREX", "NOK.FOREX",
    "NZD.FOREX", "ZAR.FOREX", "SEK.FOREX", "DKK.FOREX", "BRL.FOREX",
    "ZAC.FOREX", "MXN.FOREX", "TWD.FOREX", "KRW.FOREX",
    "CLP.FOREX", "CZK.FOREX", "HUF.FOREX", "IDR.FOREX",
    "ISK.FOREX", "MXV.FOREX", "PLN.FOREX", "TRY.FOREX", "UYU.FOREX"
  ];

  static List<String> fiatCurrenciesNames = [
    "united_states_dollar", "euro", "russian_ruble",
    "british_pound_sterling", "yuan",
    "japanese_yen", "singapore_dollar", "indian_rupee",
    "swiss_franc", "australian_dollar",
    "canadian_dollar", "hong_kong_dollar", "malaysian_ringgit",
    "norwegian_krone", "new_zealand_dollar", "south_african_rand",
    "swedish_krona", "danish_krone", "brazilian_real",
    "south_african_cents", "mexican_peso", "new_taiwan_dollar",
    "south_korean_won", "chilean_peso", "czech_koruna",
    "hungarian_forint", "indonesian_rupiah",
    "icelandic_krona", "mexican_peso_to_inversion", "polish_zloty",
    "turkish_lira", "uruguayan_peso"

  ];



  static List<Widget> flags = [
    Flag.fromCode(FlagsCode.US, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.EU, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.RU, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.GB, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.CN, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.JP, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.SG, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.IN, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.CH, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.AU, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.CA, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.HK, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.MY, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.NO, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.NZ, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.ZA, height: 50, fit: BoxFit.fitHeight,),


    Flag.fromCode(FlagsCode.SE, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.DK, height: 50, fit: BoxFit.fitHeight,),


    Flag.fromCode(FlagsCode.BR, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.ZA, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.MX, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.TW, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.KR, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.CL, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.CZ, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.HU, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.ID, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.IS, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.MX, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.PL, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.TR, height: 50, fit: BoxFit.fitHeight,),

    Flag.fromCode(FlagsCode.UY, height: 50, fit: BoxFit.fitHeight,),



  ];


  static List<String> cryptocurrenciesCodes = [
    "BTC-USD.CC", "ETH-USD.CC", "ADA-USD.CC",
    "BNB-USD.CC", "USDT-USD.CC", "XRP-USD.CC",
    "SOL-USD.CC", "DOT-USD.CC", "DOGE-USD.CC",
    "USDC-USD.CC", "UNI-USD.CC", "LUNA-USD.CC",
    "LINK-USD.CC", "BUSD-USD.CC", "LTC-USD.CC",
    "BCH-USD.CC", "AVAX-USD.CC", "ALGO-USD.CC",
    "WBTC-USD.CC", "ICP-USD.CC"
  ];


  static List<String> cryptocurrenciesNames = [
    "Bitcoin", "Ethereum", "Cardano", "Binance Coin",
    "Tether", "XRP", "Solana", "Polkadot", "Dogecoin",
    "USD Coin", "Uniswap", "Terra", "Chainlink", "Binance USD",
    "Litecoin", "Bitcoin Cash", "Avalanche", "Algorand", "Wrapped Bitcoin",
    "Internet Computer"
  ];




  static List<String> assetsCodes = [
    "6A.COMM", "6B.COMM", "6C.COMM", "6E.COMM",
    "6J.COMM", "6L.COMM", "6N.COMM", "6R.COMM",
    "6S.COMM", "6Z.COMM", "BMC.COMM", "BO.COMM",
    "BZ.COMM", "CACF.COMM", "CB.COMM", "CC.COMM",
    "CFI2Z1.COMM", "CGB.COMM", "CL.COMM", "CT.COMM",
    "DAXF.COMM", "DC.COMM", "DJ.COMM", "DX.COMM",
    "DY.COMM", "EH.COMM", "ES.COMM", "FC.COMM",
    "FGBL.COMM", "FGBM.COMM", "FGBS.COMM", "FMEM.COMM",
    "FVS.COMM", "FVZ0.COMM", "GC.COMM", "GDK.COMM",
    "GE.COMM", "GF.COMM", "HG.COMM", "HO.COMM",
    "HRC.COMM", "HSI.COMM", "HSTI.COMM", "IBEXF.COMM",
    "IT40F.COMM", "KC.COMM", "LB.COMM", "LCO.COMM",
    "LE.COMM", "LH.COMM", "MALTR.COMM"
  ];


  static List<String> assetsNames = [
    "Australian Dollar Futures", "British Pound Futures",
    "Canadian Dollar Futures", "Euro FX Futures",
    "Japanese Yen Futures", "Brazilian Real Futures",
    "New Zealand Dollar Futures", "Russian Ruble Futures",
    "Swiss Franc Futures", "South African Rand Futures",
    "Bitcoin Futures CME", "Soybean Oil",  "Brent Crude",
    "CAC 40 Futures", "Cash-settled Butter Futures",
    "Cocoa", "Carbon Emissions Futures", "Canada Government Bond 10Y Futures",
    "Crude Oil", "Cotton", "DAX Futures", "Class III Milk Futures",
    "Dow Jones Futures", "Dollar Index Future", "Dry Whey Futures",
    "EH", "E-Mini S&P 500", "Feeder Cattle Futures", "Euro Bund Futures",
    "Euro BOBL Futures", "Euro SCHATZ Futures", "MSCI Emerging Markets Equity Futures",
    "VSTOXX Mini Futures", "US 5 Year T-Note Contract", "Gold",
    "Class IV Milk Futures", "Eurodollar Futures", "Feeder Cattle Futures",
    "Copper", "NY Harbor ULSD Futures", "US Midwest Domestic Hot-Rolled Coil Steel Futures",
    "Hang Seng Index Futures", "Hang Seng Tech Index Futures",
    "IBEX Futures",  "FTSE MIB Futures", "Coffee", "Lumber",
    "ICE Brent Crude", "Live Cattle Futures", "Lean Hogs",
    "Aluminum"
  ];


  static List<CurrencyData> loadMainFiats () {

    return [CurrencyData(code: "USD.FOREX", name: "United States Dollar"),
    CurrencyData(code: "EUR.FOREX", name: "EURO"),
    CurrencyData(code: "GBP.FOREX", name: "British Pound"),
    CurrencyData(code: "CAD.FOREX", name: "Canadian Dollar"),
    CurrencyData(code: "AUD.FOREX", name: "Australian Dollar")];
  }

  static List<CurrencyData> loadMainCrypto() {
    return [CurrencyData(code: "BTC-USD.CC", name: "Bitcoin"),
      CurrencyData(code: "ETH-USD.CC", name: "Ethereum"),
      CurrencyData(code: "ADA-USD.CC", name: "Cardano"),
      CurrencyData(code: "BNB-USD.CC", name: "Binance Coin"),
      CurrencyData(code: "USDT-USD.CC", name: "Tether")];
  }

  static List<CurrencyData> loadMainAssets() {
    return [CurrencyData(code: "KC.COMM", name: "Coffee"),
      CurrencyData(code: "GC.COMM", name: "Gold"),
      CurrencyData(code: "HG.COMM", name: "Copper"),
      CurrencyData(code: "MALTR.COMM", name: "Aluminum"),
      CurrencyData(code: "CL.COMM", name: "Crude Oil")];
  }

  static List<CurrencyData> loadMainShares() {
    return [CurrencyData(code: 'AAPL.US', name: 'Apple Inc'),
      CurrencyData(code:'TSLA.US', name: 'Tesla Inc'),
      CurrencyData(code: 'AMZN.US', name: 'Amazon.com Inc'),
      CurrencyData(code: 'MSFT.US', name: 'Microsoft Corporation'),
      CurrencyData(code: 'PYPL.US', name: 'PayPal Holdings Inc')];
  }


  static Future<List<Map<String, dynamic>>> loadFiatCurrencies () async{

    List<Map<String, dynamic>> _fiatMapList = [];

      var request = await Dio().get("https://eodhistoricaldata.com/api/exchange-symbol-list/FOREX?api_token=${AppDatabase.apiToken}");

      int counter = 0;
      for(String fiat in (request.data as String).split("\n")) {
        List<String> elements = fiat.split(",");

        if(counter > 0) {
          if(elements[0].length == 3) {
            if (elements.length >= 5) {
              _fiatMapList.add({
                "code": elements[0],
                "name": elements[1],
                "country": elements[2],
                "exchange": elements[3],
                "currency": elements[4],

              });
            }
          }

        }

        counter ++;





      }


      return _fiatMapList;





  }


  static Future<List<Map<String, dynamic>>> loadCryptoCurrencies() async{
    List<Map<String, dynamic>> _cryptoMapList = [];

    var request = await Dio().get("https://eodhistoricaldata.com/api/exchange-symbol-list/CC?api_token=${AppDatabase.apiToken}");

    int counter = 0;
    for(String crypto in (request.data as String).split("\n")) {
      List<String> elements = crypto.split(",");

      if(counter > 0) {

          if (elements.length >= 5) {
            _cryptoMapList.add({
              "code": elements[0],
              "name": elements[1],
              "country": elements[2],
              "exchange": elements[3],
              "currency": elements[4],

            });
          }


      }

      counter ++;





    }

    return _cryptoMapList;


  }


  static Future<List<Map<String, dynamic>>> loadAssets() async{
    List<Map<String, dynamic>> _commoditiesMapList = [];

    var request = await Dio().get("https://eodhistoricaldata.com/api/exchange-symbol-list/COMM?api_token=${AppDatabase.apiToken}");

    int counter = 0;
    for(String commodity in (request.data as String).split("\n")) {
      List<String> elements = commodity.split(",");

      if(counter > 0) {

        if (elements.length >= 5) {
          _commoditiesMapList.add({
            "code": elements[0],
            "name": elements[1],
            "country": elements[2],
            "exchange": elements[3],
            "currency": elements[4],

          });
        }


      }

      counter ++;





    }

    return _commoditiesMapList;



  }

  static Future<List<Map<String, dynamic>>> loadShares() async{
    List<Map<String, dynamic>> _sharesMapList = [];

    var request = await Dio().get("https://eodhistoricaldata.com/api/exchange-symbol-list/US?api_token=${AppDatabase.apiToken}");

    int counter = 0;
    for(String share in (request.data as String).split("\n")) {
      List<String> elements = share.split(",");

      if(counter > 0) {

        if (elements.length >= 5) {
          _sharesMapList.add({
            "code": elements[0],
            "name": elements[1],
            "country": elements[2],
            "exchange": elements[3],
            "currency": elements[4],

          });
        }


      }

      counter ++;





    }

    return _sharesMapList.sublist(0, 50);



  }

  static Future<List<Map<String, dynamic>>> loadSharesWithOffset(int offset) async{
    List<Map<String, dynamic>> _sharesMapList = [];

    var request = await Dio().get("https://eodhistoricaldata.com/api/exchange-symbol-list/US?api_token=${AppDatabase.apiToken}");

    int counter = 0;
    for(String share in (request.data as String).split("\n")) {
      List<String> elements = share.split(",");

      if(counter > 0) {

        if (elements.length >= 5) {
          _sharesMapList.add({
            "code": elements[0],
            "name": elements[1],
            "country": elements[2],
            "exchange": elements[3],
            "currency": elements[4],

          });
        }


      }

      counter ++;





    }

    return _sharesMapList.sublist(offset, offset + 50);



  }




}