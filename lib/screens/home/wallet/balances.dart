import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/currencyData.dart';
import 'package:app_p2p/localDatabase/localDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/displayBalance.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Balances extends StatefulWidget {

  int? type;
  Balances({this.type});

  @override
  _BalancesState createState() => _BalancesState(type: type);
}

class _BalancesState extends State<Balances> {

  int? type;
  _BalancesState({this.type});


  String get balanceType {
    if(type == 0) {
      return loc(context, "more_fiats");
    }else if(type == 1) {
      return loc(context, "more_crypto");
    }else if(type == 2) {
      return loc(context, "more_assets");
    }

    return loc(context, "fiat");
  }


  List<Widget> _balances = [];

  @override
  void initState() {

    if(type == 0) {
      loadFiatCurrencies();
    }else if(type == 1) {
      loadCryptoCurrencies();
    }else if(type == 2) {
      loadAssetsCurrencies();
    }
    super.initState();
  }



  bool _loadingBalances = false;


  void loadFiatCurrencies() async{

    setState(() {
      _loadingBalances = true;
    });
    LocalDatabase.loadCurrencies(0).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData fiat in currencies) {




          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: fiat.name, currencyCode: fiat.code,
              isFiat: true,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));
        }
        setState(() {
          _loadingBalances = false;
        });

        print("Fiat currencies loaded locally!");

      }else {
        loadFiatRemotely();
      }

    });



  }

  void loadFiatRemotely () async{
    setState(() {
      _loadingBalances = true;
    });


    List<CurrencyData> _currencyList = [];

    for(Map<String, dynamic> fiatMap in await CurrenciesManager.loadFiatCurrencies()) {

      CurrencyData fiat = CurrencyData.fromMap(fiatMap);

      _currencyList.add(fiat);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: fiat.name, currencyCode: fiat.code,
          isFiat: true,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));


        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));


    }

    setState(() {
      _loadingBalances = false;
    });



    LocalDatabase.insertAll(_currencyList, 0);
  }




  int _limit = 50;
  void loadCryptoCurrencies () async{

    setState(() {
      _loadingBalances = true;
    });

    LocalDatabase.loadCurrencies(1).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData crypto in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: crypto.name, currencyCode: crypto.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));


        }

        setState(() {
          _loadingBalances = false;
        });

        print("Crypto loaded locally!");
      }else {
        loadCryptoRemotely();
      }



    });




  }




  void loadCryptoRemotely() async{

    List<CurrencyData> _currencyList = [];
    int counter = 0;
    for(Map<String, dynamic> cryptoMap in await CurrenciesManager.loadCryptoCurrencies()) {

      CurrencyData crypto = CurrencyData.fromMap(cryptoMap);

      _currencyList.add(crypto);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: crypto.name, currencyCode: crypto.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));

      counter ++;

    }

    print("Crypto loaded remotely");
    setState(() {
      _loadingBalances = false;
    });

    LocalDatabase.insertAll(_currencyList, 1);
  }








  void loadAssetsCurrencies() async{

    setState(() {
      _loadingBalances = true;
    });

    LocalDatabase.loadCurrencies(2).then((currencies) {

      if(currencies.length > 0) {

        for(CurrencyData commodities in currencies) {
          BalanceData balanceData = BalanceData(amount: 0.0,
              currencyName: commodities.name, currencyCode: commodities.code,
              isFiat: false,
              created: DateTime.now());

          _balances.add(BalanceItem(data: balanceData,
            onPressed: (data, exchange) {

              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

                  },)));
            }, onlyShow: true,));
          _balances.add(SizedBox(height: 20,));
        }

        setState(() {
          _loadingBalances = false;
        });

        print("Assets loaded locally!");


      }else {
        loadAssetsRemotely();
      }

    });

  }

  void loadAssetsRemotely() async{

    List<CurrencyData> _currencyList = [];

    for(Map<String, dynamic> commoditiesMap in await CurrenciesManager.loadAssets()) {

      CurrencyData commodities = CurrencyData.fromMap(commoditiesMap);

      _currencyList.add(commodities);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: commodities.name, currencyCode: commodities.code,
          isFiat: false,
          created: DateTime.now());

      _balances.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {

              },)));
        }, onlyShow: true,));
      _balances.add(SizedBox(height: 20,));
    }

    setState(() {
      _loadingBalances = false;
    });

    LocalDatabase.insertAll(_currencyList, 2);
    print("Assets loaded remotely");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(balanceType, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: _loadingBalances? Column(
              children: [
                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
                    ),
                  ),
                )

              ],
            ) : Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ListView(
                        children: _balances,
                      ),
                    )
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}