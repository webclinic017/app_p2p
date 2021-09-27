import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/components/balanceItemPlaceHolder.dart';
import 'package:app_p2p/database/currencyData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localDatabase/localDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/transactions/receiveMoney.dart';
import 'package:app_p2p/screens/home/transactions/sendMoney.dart';
import 'package:app_p2p/screens/home/wallet/addFunds/addFunds.dart';
import 'package:app_p2p/screens/home/wallet/balances.dart';
import 'package:app_p2p/screens/home/wallet/components/walletOptions.dart';
import 'package:app_p2p/screens/home/wallet/displayBalance.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/currenciesColors.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {


  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {



  double _totalUsd = 0.0;
  String _totalUsdFormatted = "";

  bool _showOptions = false;


  bool _loadingBalances = false;

  void calculatingUSDBalance() async{
    var firestore = FirebaseFirestore.instance;

    _totalUsd = 0.0;

    print("Calculating usd balance");

    setState(() {
      _loadingBalances = true;
      _balances.clear();
    });
    var query = await firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.balances).orderBy(AppDatabase.amount, descending: true).get();

    print("Balances loaded: ${query.docs.length}");

    List<BalanceData> balances = [];
    for(var doc in query.docs) {
      BalanceData balanceData = BalanceData.fromDoc(doc);
      balances.add(balanceData);
      setState(() {
        _balances.add(BalanceItem(data: balanceData, isMine: true,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {
                calculatingUSDBalance();
              },)));

        },));
        _balances.add(SizedBox(height: 20,));
      });
    }




    setState(() {
      _loadingBalances = false;
    });
    for(BalanceData balance in balances) {

      double amountInUsd = await getCurrencyInUSD(balance);

      _totalUsd += amountInUsd;


    }

    NumberFormat format = NumberFormat.currency(locale: "en_US", decimalDigits: 2, name: "");
    _totalUsdFormatted = format.format(_totalUsd);
    setState(() {

    });

  }

  Future<double> getCurrencyInUSD (BalanceData balance) async{
    var firestore = FirebaseFirestore.instance;

    var query = await firestore.collection(AppDatabase.recentExchangeRates)
        .where(AppDatabase.code, isEqualTo: balance.currencyCode).get();

    if(query.docs.length > 0) {
      return (ExchangeData.fromDoc(query.docs.first).close as double) * (balance.amount as double);
    }

    try {
      var response = await Dio().get("${AppDatabase.historicalDataEndPoint}${balance.currencyCode}?api_token=${AppDatabase.apiToken}${AppDatabase.historicalDataHeaders}");

      return (ExchangeData.fromMap(response.data as Map<String, dynamic>).close as double) * (balance.amount as double) ;

    }catch(e) {
      return 0.0;
    }

  }


  List<Widget> _balances = [];


  int _selectedIndex = 0;


  bool _loadingFiatCurrencies = false;
  List<Widget> _fiatCurrencies = [];

  void loadFiatCurrencies() async{

    setState(() {
      _loadingFiatCurrencies = true;
    });


    List<CurrencyData> _currencyList = [];

    for(CurrencyData fiat in CurrenciesManager.loadMainFiats()) {


      _currencyList.add(fiat);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: fiat.name, currencyCode: fiat.code,
          isFiat: true,
          created: DateTime.now());

      _fiatCurrencies.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {
                calculatingUSDBalance();
              },)));


        }, onlyShow: true,));
      _fiatCurrencies.add(SizedBox(height: 20,));


    }

    setState(() {
      _loadingFiatCurrencies = false;
    });




  }









  bool _loadingCryptocurrencies = false;
  List<Widget> _cryptocurrencies = [];
  int _limit = 50;
  void loadCryptoCurrencies () async{

    setState(() {
      _loadingCryptocurrencies = true;
    });

    List<CurrencyData> _currencyList = [];
    int counter = 0;
    for(CurrencyData crypto in CurrenciesManager.loadMainCrypto()) {


      _currencyList.add(crypto);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: crypto.name, currencyCode: crypto.code,
          isFiat: false,
          created: DateTime.now());

      _cryptocurrencies.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {
                calculatingUSDBalance();
              },)));
        }, onlyShow: true,));
      _cryptocurrencies.add(SizedBox(height: 20,));

      counter ++;

      if(counter == _limit) {
        break;
      }
    }


    setState(() {
      _loadingCryptocurrencies = false;
    });




  }











  bool _loadingAssets = false;
  List<Widget> _assets = [];
  void loadAssetsCurrencies() async{

    setState(() {
      _loadingAssets = true;
    });

    List<CurrencyData> _currencyList = [];

    for(CurrencyData commodities in CurrenciesManager.loadMainAssets()) {



      _currencyList.add(commodities);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: commodities.name, currencyCode: commodities.code,
          isFiat: false,
          created: DateTime.now());

      _assets.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {
                calculatingUSDBalance();
              },)));
        }, onlyShow: true,));
      _assets.add(SizedBox(height: 20,));
    }

    setState(() {
      _loadingAssets = false;
    });

  }




  List<Widget> _shares = [];

  void loadShares() async{



    List<CurrencyData> _currencyList = [];

    for(CurrencyData shares in CurrenciesManager.loadMainShares()) {



      _currencyList.add(shares);

      BalanceData balanceData = BalanceData(amount: 0.0,
          currencyName: shares.name, currencyCode: shares.code,
          isFiat: false,
          created: DateTime.now());

      _shares.add(BalanceItem(data: balanceData,
        onPressed: (data, exchange) {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DisplayBalance(data: data, exchangeData: exchange, onBalanceOpened: () {
                calculatingUSDBalance();
              },)));
        }, onlyShow: true,));
      _shares.add(SizedBox(height: 20,));
    }



  }



  TabController? _tabController;

  @override
  void initState() {
    calculatingUSDBalance();
    loadFiatCurrencies();
    loadCryptoCurrencies();
    loadAssetsCurrencies();
    loadShares();

    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 240, 240, 1.0)
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.secondary, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width: double.infinity,
                                child: Text(loc(context, "b_dollars"),
                                style: TextStyle(fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.5)),
                                textAlign: TextAlign.center, ),
                              ),

                              SizedBox(height: 5,),

                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("\$", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.5)),),

                                    SizedBox(width: 5,),

                                    Text("$_totalUsdFormatted",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
                                          color: Colors.black),)
                                  ],
                                ),
                              )

                            ],
                          )
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(loc(context, "your_balances"),
                      style: TextStyle(fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.7)),),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _loadingBalances? Column(
                      children: [
                        BalanceItemPlaceHolder(),
                        SizedBox(height: 10,),
                        BalanceItemPlaceHolder(),
                        SizedBox(height: 10,),
                        BalanceItemPlaceHolder()


                      ],
                    ) : Column(
                      children: _balances,
                    ),
                  ),

                  SizedBox(height: 30,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(loc(context, "currencies_and_assets"),
                      style: TextStyle(fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.5)),),
                  ),

                  SizedBox(height: 10,),


                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.secondary,
                      tabs: [
                        Tab(child: Text(loc(context, "fiat"), style: TextStyle(color: Colors.black),),),
                        Tab(child: Text(loc(context, "crypto"), style: TextStyle(color: Colors.black),),),
                        Tab(child: Text(loc(context, "assets"), style: TextStyle(color: Colors.black),),),
                        Tab(child: Text(loc(context, "shares"), style: TextStyle(color: Colors.black),),),
                      ],
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),

                  _selectedIndex == 0? SizedBox(height: 20,) : Container(),


                  _selectedIndex == 0? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _loadingBalances? Column(
                      children: [

                        BalanceItemPlaceHolder(),
                        SizedBox(height: 10,),
                        BalanceItemPlaceHolder(),
                        SizedBox(height: 10,),
                        BalanceItemPlaceHolder(),


                      ],
                    ) : Column(
                      children: _fiatCurrencies,
                    )
                  ) : Container(),

                  _selectedIndex == 0? Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Balances(
                                type: 0,
                              )));
                            },
                            child: Text(loc(context, "see_more"),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                  color: AppColors.secondary),),
                          ),
                        )
                      ],
                    ),
                  ) : Container(),




                  _selectedIndex == 1? SizedBox(height: 10,) : Container(),

                  _selectedIndex == 1? Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _loadingBalances? Column(
                        children: [
                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),


                        ],
                      ) : Column(
                        children: _cryptocurrencies,
                      )
                  ) : Container(),

                  _selectedIndex == 1? Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Balances(
                                type: 1,
                              )));
                            },
                            child: Text(loc(context, "see_more"),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                            color: AppColors.secondary),),
                          ),
                        )
                      ],
                    ),
                  ) : Container(),


                  _selectedIndex == 2? SizedBox(height: 10,) : Container(),

                  _selectedIndex == 2? Container(
                      width: double.infinity,

                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _loadingBalances? Column(
                        children: [

                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),

                        ],
                      ) : Column(
                        children: _assets,
                      )
                  ) : Container(),

                  _selectedIndex == 2? Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Balances(
                                type: 2,
                              )));
                            },
                            child: Text(loc(context, "see_more"),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                  color: AppColors.secondary),),
                          ),
                        )
                      ],
                    ),
                  ) : Container(),

                  _selectedIndex == 3? SizedBox(height: 10,) : Container(),

                  _selectedIndex == 3? Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _loadingBalances? Column(
                        children: [
                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),
                          SizedBox(height: 10,),
                          BalanceItemPlaceHolder(),


                        ],
                      ) : Column(
                        children: _shares,
                      )
                  ) : Container(),

                  _selectedIndex == 3? SizedBox(height: 10,) : Container(),

                  _selectedIndex == 3? Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Balances(
                                type: 3,
                              )));
                            },
                            child: Text(loc(context, "see_more"),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                  color: AppColors.secondary),),
                          ),
                        )
                      ],
                    ),
                  ) : Container(),

                  SizedBox(height: 50,),





                ],
              ),
            )
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                ),
                child: Material(
                  color: Colors.white.withOpacity(0.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {

                      setState(() {
                        _showOptions = true;
                      });



                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.add, color: Colors.white,),
                    ),
                  ),
                ),
              ),
            ),
          ),

          _showOptions? WalletOptions(onClose: () {

            setState(() {
              _showOptions = false;
            });

          },
          onSendMoneyPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoney()));

          },
          onReceiveMoneyPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveMoney()));
          },
          onAddFundsPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFunds()));
          },) : Container()




        ],
      ),
    );
  }
}
