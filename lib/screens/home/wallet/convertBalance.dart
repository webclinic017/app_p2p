import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/balanceItemPlaceHolder.dart';
import 'package:app_p2p/components/balancePicker.dart';
import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ConvertBalance extends StatefulWidget {

  BalanceData? from;
  ConvertBalance({this.from});

  @override
  _ConvertBalanceState createState() => _ConvertBalanceState(from: from);
}

class _ConvertBalanceState extends State<ConvertBalance> {

  BalanceData? from;
  _ConvertBalanceState({this.from});

  bool _isLoading = false;
  String _loadMessage = "";

  BalanceData? to;

  double _totalUsd = 0.0;
  String _totalUsdFormatted = "";

  List<BalanceData> _balances = [];

  String? _selectedFromCurrency;
  String? _selectedToCurrency;
  double _fromValue = 0.0;
  double _toValue = 0.0;

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();


  bool _loadingBalances = false;

  void calculatingUSDBalance() async{
    var firestore = FirebaseFirestore.instance;

    _totalUsd = 0.0;

    print("Calculating usd balance");

    setState(() {
      _loadingBalances = true;
    });
    var query = await firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.balances).orderBy(AppDatabase.amount, descending: true).get();

    print("Balances loaded: ${query.docs.length}");


    for(var doc in query.docs) {
      BalanceData balanceData = BalanceData.fromDoc(doc);
      _balances.add(balanceData);
      setState(() {

      });
    }


    setState(() {
      _loadingBalances = false;
    });
    for(BalanceData balance in _balances) {

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

  ExchangeData? _fromExchangeData;
  ExchangeData? _toExchangeData;


  double? get fromTo {

    if(_fromExchangeData != null && _toExchangeData != null) {

      return (_fromExchangeData?.close as double) / (_toExchangeData?.close as double);
    }else {
      return null;
    }
  }

  double? get toFrom {
    if(_fromExchangeData != null && _toExchangeData != null) {

      return (_toExchangeData?.close as double) / (_fromExchangeData?.close as double) ;
    }else {
      return null;
    }
  }

  Future<void> currentExchangeData(bool isFrom) async {
    var firestore = FirebaseFirestore.instance;

    var query = await firestore.collection(AppDatabase.recentExchangeRates)
        .where(AppDatabase.code, isEqualTo: isFrom? "${from?.currencyCode}" : "${to?.currencyCode}").get();

    // print("Docs length: ${query.docs.length}");

    if(query.docs.length > 0) {
      for (var doc in query.docs) {
        ExchangeData exchangeData = ExchangeData.fromDoc(doc);

        if (DateTime.now().difference(exchangeData.time as DateTime) <
            Duration(minutes: 30)) {

          if(isFrom) {
            setState(() {
              _fromExchangeData = exchangeData;
            });
          }else {
            setState(() {
              _toExchangeData = exchangeData;
            });
          }

          //print("DATA TAKEN FROM FIREBASE");
        } else {
          //print("MORE THAN 30 MINUTES HAS BEEN PASSED");
          await registerExchange(doc.id, isFrom);
        }
      }
    }else {
      await registerExchange(null, isFrom);
    }
  }

  Future<void> registerExchange (String? exchangeID, bool isFrom) async{
    var firestore = FirebaseFirestore.instance;


    try {
      var response = await Dio().get(
          "${AppDatabase.historicalDataEndPoint}${isFrom? from?.currencyCode : to?.currencyCode}?api_token=${AppDatabase.apiToken}${AppDatabase
              .historicalDataHeaders}");

      //   print("REQUEST PERFORMED TO API");

      print("Response returned: ${response.data as Map<String, dynamic>}");

      ExchangeData newExchangeData = ExchangeData.fromMap(
          response.data as Map<String, dynamic>);


      if (exchangeID != null) {
        await firestore.collection(AppDatabase.recentExchangeRates).doc(
            exchangeID)
            .update(newExchangeData.toMap());
      } else {
        await firestore.collection(AppDatabase.recentExchangeRates).add(
            newExchangeData.toMap());
      }

      if(isFrom) {
        setState(() {
          _fromExchangeData = newExchangeData;
        });
      }else {
        setState(() {
          _toExchangeData = newExchangeData;
        });
      }


    }on DioError catch (e) {

      print("Error: ${e.response?.data}");
    }



  }

  @override
  void initState() {
    calculatingUSDBalance();
    //currentExchangeData();


    currentExchangeData(true);

    setState(() {
      _fromController.text = "0.0";
      _toController.text = "0.0";
    });

    _selectedFromCurrency = from?.currencyCode as String;
    super.initState();
  }


  void fromFormatting() {
    setState(() {
      _fromController.text = _fromValue.toString();
    });

    if(fromTo != null) {
      _toValue = (fromTo as double) * _fromValue;
      setState(() {
        _toController.text = _toValue.toString();
      });
    }
  }

  void toFormatting () {

    if(toFrom != null) {
      _fromValue = (toFrom as double) * _toValue;

      if(_fromValue > (from?.amount as double)) {
        _fromValue = from?.amount as double;
        _toValue = _fromValue / (toFrom as double);


      }
      setState(() {
        _toController.text = _toValue.toString();
        _fromController.text = _fromValue.toString();
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "convert_balance"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios)),


      ),
      body: Stack(
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
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "balance"), style: TextStyle(color: Colors.black),),
                  ),

                  SizedBox(height: 5,),

                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        children: [
                          Text("${_totalUsdFormatted}", style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600,
                              color: Colors.black
                          ),),
                          SizedBox(width: 7,),

                          Text("B-Dollars", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.5)),)
                        ],
                      )
                  ),


                  SizedBox(height: 50,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "from"), style: TextStyle(color: Colors.black),),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _fromController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.number,
                                onTap: () {


                                  print("on Tap called!");
                                  fromFormatting();
                                  toFormatting();
                                },
                                onFieldSubmitted: (value) {
                                  print("Field submitted!");

                                  fromFormatting();
                                  toFormatting();
                                },

                                onChanged: (value) {

                                  try {
                                    setState(() {
                                      _fromValue = double.parse(value);
                                    });

                                    for(var bData in _balances.where((element) => element.currencyCode == from?.currencyCode)) {
                                      if(_fromValue  > (bData.amount as double)) {
                                        setState(() {
                                          _fromValue  = bData.amount as double;
                                        });

                                      }
                                    }



                                    print("FromValue: $_fromValue");
                                  }catch(e) {
                                    _fromValue  = 0.0;

                                    print("An error has occurred: ${e}");
                                  }

                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),


                        Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                          ),
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BalancePicker(
                                  onBalanceSelected: (data) async{
                                    setState(() {
                                      from = data;
                                    });
                                    await currentExchangeData(true);

                                    if(_fromValue > (from?.amount as double)) {
                                      setState(() {
                                        _fromValue = from?.amount as double;
                                        _fromController.text = _fromValue.toString();
                                      });
                                    }

                                    if(fromTo != null) {
                                      _toValue = (fromTo as double) * _fromValue;
                                      setState(() {
                                        _toController.text = _toValue.toString();
                                      });
                                    }
                                  },
                                )));
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: from != null?Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: AppColors.form,
                                          shape: BoxShape.circle
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: from?.isFiat == true? CurrenciesManager.getFlag(from?.currencyCode as String) : Align(
                                            alignment: Alignment.center,
                                            child: Text(from?.currencyCode?[0] as String),
                                          )
                                      ),
                                    ),

                                    SizedBox(width: 5,),

                                    Text(from?.currencyCode?.substring(0, 3) as String)

                                  ],
                                ) : Text("-"),
                              ),
                            ),
                          ),
                        )


                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          width: 80,
                          child: FittedBox(
                            child: Text(from != null? "${from?.amount.toString()} ${from?.currencyCode?.substring(0, 3)}" : "-",
                              style: TextStyle(color: Colors.black),),
                          ),
                        )
                      ],
                    ),
                  ),


                  SizedBox(height: 30,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "to"), style: TextStyle(color: Colors.black),),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                controller: _toController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.number,
                                onTap: () {
                                  toFormatting();
                                  fromFormatting();
                                },
                                onFieldSubmitted: (value) {
                                  toFormatting();
                                  fromFormatting();
                                },
                                onChanged: (value) {

                                  try {
                                    setState(() {
                                      _toValue = double.parse(value);
                                    });

                                    for(var bData in _balances.where((element) => element.currencyCode == _selectedToCurrency)) {
                                      if(_toValue  > (bData.amount as double)) {
                                        setState(() {
                                          _toValue  = bData.amount as double;
                                        });

                                      }
                                    }



                                    print("toValue: $_fromValue");
                                  }catch(e) {
                                    _toValue  = 0.0;
                                  }


                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),


                        Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                          ),
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BalancePicker(
                                  onBalanceSelected: (data) async{
                                    setState(() {
                                      to = data;
                                    });
                                    await currentExchangeData(false);


                                    if(_toValue > (to?.amount as double)) {
                                      setState(() {
                                        _toValue = to?.amount as double;
                                        _toController.text = _toValue.toString();
                                      });
                                    }

                                    if(fromTo != null) {
                                      _toValue = (fromTo as double) * _fromValue;
                                      setState(() {
                                        _toController.text = _toValue.toString();
                                      });
                                    }
                                  },
                                )));
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: to != null?Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: AppColors.form,
                                          shape: BoxShape.circle
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: to?.isFiat == true? CurrenciesManager.getFlag(to?.currencyCode as String) : Align(
                                          alignment: Alignment.center,
                                          child: Text((to?.currencyCode?[0]) as String),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 5,),

                                    Text(to?.currencyCode?.substring(0, 3) as String)

                                  ],
                                ) : Text("-"),
                              ),
                            ),
                          ),
                        )


                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: fromTo != null? Text("1 ${_fromExchangeData?.code?.substring(0, 3)} = ${fromTo} ${_toExchangeData?.code?.substring(0,3)}",
                      style: TextStyle(color: Colors.black),) : Text("-", style: TextStyle(color: Colors.black)),
                  ),



                  SizedBox(height: 50,),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(fromTo != null? 1.0 : 0.5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                    ),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: fromTo != null? () {

                          AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
                          content: "${loc(context, "do_you_want_to_convert")} ${_fromValue.toString()} ${from?.currencyCode?.substring(0, 3)} "
                              "${loc(context, "into_lowercase")} ${_toValue.toString()} ${to?.currencyCode?.substring(0, 3)}",
                          actions: [loc(context, "cancel_uppercase"),
                          loc(context, "convert_uppercase")],
                          callbacks: [
                            () {

                            Navigator.pop(context);
                            }, () {
                              Navigator.pop(context);
                              performConversion();
                            }
                          ]);


                        } : null,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(loc(context, "convert_uppercase"),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                color: fromTo != null? Colors.white : Colors.white.withOpacity(0.5)),),
                        ),
                      ),
                    ),
                  )







                ],
              ),
            )
          ),

          _isLoading? Loader(loadMessage: _loadMessage,) : Container()

        ],
      )
    );
  }

  void performConversion () {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "converting")}..";
    });


    firestore.runTransaction((transaction) async {

      var fromDocRef = firestore.collection(AppDatabase.users).doc(userID)
          .collection(AppDatabase.balances).doc(from?.id);



      var fromBalanceDoc = await transaction.get(fromDocRef);

      double currentFromAmount = double.parse(fromBalanceDoc.data()?[AppDatabase.amount].toString() as String);

      currentFromAmount -= _fromValue;



      var toDocRef = firestore.collection(AppDatabase.users).doc(userID)
          .collection(AppDatabase.balances).doc(to?.id);

      var toBalanceDoc = await transaction.get(toDocRef);

      double currentToAmount = double.parse(toBalanceDoc.data()?[AppDatabase.amount].toString() as String);

      currentToAmount += _toValue;


      transaction.update(fromDocRef, {
        AppDatabase.amount: currentFromAmount
      });

      return transaction.update(toDocRef, {
        AppDatabase.amount: currentToAmount
      });


    }).then((result) {

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: loc(context, "conversion_performed"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(currentScreen: 1,)), (route) => false);


    });
  }
}










