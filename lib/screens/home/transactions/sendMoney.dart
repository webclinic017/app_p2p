import 'dart:io';

import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/balancePicker.dart';
import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/components/simpleUserItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/home.dart';
import 'package:app_p2p/screens/home/transactions/qrScanner.dart';
import 'package:app_p2p/screens/home/transactions/transactionSuccess.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

class SendMoney extends StatefulWidget {



  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {


  UserData? _receiverUser;
  BalanceData? _targetWallet;
  
  bool _showMethodChooser = false;

  double _amount = 0.0;
  double _finalAmount = 0.0;

  bool _isLoading = false;
  String _loadMessage = "";

  ExchangeData? _receiverExchange;
  BalanceData? _fundsSource;
  ExchangeData? _fundsSourceExchange;


  double _totalUsd = 0.0;
  String _totalUsdFormatted = "";

  TextEditingController _amountController = TextEditingController();

  double _commission = 0.0;


  void calculatingUSDBalance() async{
    var firestore = FirebaseFirestore.instance;

    _totalUsd = 0.0;

    print("Calculating usd balance");


    var query = await firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.balances).orderBy(AppDatabase.amount, descending: true).get();

    print("Balances loaded: ${query.docs.length}");

    List<BalanceData> balances = [];

    double amountInUsd = await getCurrencyInUSD(_fundsSource as BalanceData);

    _totalUsd += amountInUsd;

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

  @override
  void initState() {
    calculatingUSDBalance();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "send_money"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
        color: Colors.white),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
        onPressed: () {
          Navigator.pop(context);
        },),


      ),

      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "receiver")),
                  ),
                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    height: 80,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                        color: AppColors.lightForm,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                    ),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),

                        child: _receiverUser == null? Row(
                          children: [
                            SizedBox(width: 20,),

                            Text(loc(context, "select_receiver"),
                              style: TextStyle(color: Colors.black.withOpacity(0.7)),)

                          ],
                        ) : SimpleUserItem(data: _receiverUser, useMargin: false,),
                        onTap: () {

                          selectReceiver();
                        },
                      ),
                    ),
                  ),

                  _targetWallet != null? SizedBox(height: 20,) : Container(),

                  _targetWallet != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "receiver_wallet")),
                  ) : Container(),

                  _targetWallet != null? SizedBox(height: 5,) : Container(),

                  _targetWallet != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: BalanceItem(data: _targetWallet,
                      onlyShow: true, onExchangeCalculated: (exchange) {

                        setState(() {
                          _receiverExchange = exchange;
                        });

                      },),
                  ) : Container(),

                  SizedBox(height: 30,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "funds_source")),
                  ),

                  SizedBox(height: 5,),

                  _fundsSource == null?Container(
                    width: double.infinity,
                    height: 60,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                        color: AppColors.lightForm,
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
                            onBalanceSelected: (balance) {

                              setState(() {
                                _fundsSource = balance;
                                calculatingUSDBalance();
                              });

                            },
                          ), ));
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 20,),

                            Text(loc(context, "select_source"),
                            style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                          ],
                        ),
                      ),
                    ),
                  ) : Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: BalanceItem(
                      data: _fundsSource,
                      onExchangeCalculated: (exchange) {

                        setState(() {
                          _fundsSourceExchange = exchange;

                        });
                      },
                    ),
                  ),


                  SizedBox(height: 20,),


                  _fundsSource != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "amount")),
                  ) : Container(),
                  SizedBox(height: 5,),

                  _fundsSource != null? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        color: AppColors.form,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: loc(context, "amount_to_send"),
                            hintStyle: TextStyle(fontSize: 16, color: AppColors.mediumGray),
                            suffix: Text("B-dollars")

                        ),
                        keyboardType: TextInputType.number,

                        onChanged: (value) {







                          try {
                            _amount = double.parse(value);
                          }catch(e) {
                            _amount = 0.0;
                          }

                          _commission = _amount * 0.036;


                          _finalAmount = _amount - _commission;


                          setState(() {

                          });

                        },
                      ),
                    ),
                  ) : Container(),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text("${_totalUsdFormatted} B-dollars ${loc(context, "available_lowercase")}",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      children: [
                        Text("${loc(context, "the_transaction_commission_is")} ",
                        style: TextStyle(color: AppColors.mediumGray),),
                        Text("${_commission.toStringAsFixed(3)}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                        color: AppColors.secondary),),

                        Text(" B-Dollars",  style: TextStyle(color: AppColors.mediumGray),)


                      ],
                    ),
                  ),

                  SizedBox(height: 5,),


                  _receiverUser != null && _targetWallet != null && _receiverExchange != null? Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text("${_receiverUser?.firstName} ${_receiverUser?.lastName} ${loc(context, "will_receive")} ",
                            style: TextStyle(color: AppColors.mediumGray),),
                            Text("${_amount / (_targetWallet?.isFiat == false?(_receiverExchange?.close as double) : (1.0/(_receiverExchange?.close as double)))}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.secondary),),
                            Text(" ${_targetWallet?.currencyCode?.substring(0, 3)}",
                              style: TextStyle(color: AppColors.mediumGray),)
                          ],
                        ),
                      )
                  ) : Container(),




                  SizedBox(height: 50,),


                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(_receiverUser == null && _amount > 0? 0.5 : 1.0),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                    ),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: _receiverUser != null && _amount > 0? () {

                          double max = (_fundsSource?.amount as double) * (_fundsSource?.isFiat == false? (_fundsSourceExchange?.close as double) : (1.0/(_fundsSourceExchange?.close as double)));

                          print("Max: ${max}, amount: ${_amount}");
                          if(_amount > max) {
                            AppUtilities.displayDialog(context, title: loc(context, "error"),
                                content: loc(context, "insufficient_funds"),
                                actions: [
                                  loc(context, "ok_uppercase")],
                                callbacks: [() {
                                  Navigator.pop(context);
                                }]);
                            return;
                          }


                          AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
                              content: loc(context, "do_you_want_to_perform_this_transaction"),
                              actions: [loc(context, "cancel_uppercase"),
                                loc(context, "send_uppercase")],
                              callbacks: [() {
                                Navigator.pop(context);
                              }, () {
                                Navigator.pop(context);
                                sendFunds();
                              }]);



                        } : null,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(loc(context, "send_money_uppercase"),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                color: Colors.white),),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50,)





                ],
              ),
            )
          ),


          _showMethodChooser? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                onTap: () {

                  setState(() {
                    _showMethodChooser = false;
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),

                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1, blurRadius: 4, offset: Offset(0, 6))]
                      ),
                      child: Column(
                        children: [

                          Container(
                            width: double.infinity,
                            height: 60,
                            child: Material(
                              color: Colors.white.withOpacity(0.0),
                              child: InkWell(
                                onTap: () {

                                  setState(() {
                                    _showMethodChooser = false;
                                  });

                                  openQr();

                                },
                                child: Row(
                                  children: [
                                    SizedBox(width: 20,),

                                    Icon(Icons.qr_code),

                                    SizedBox(width: 10,),

                                    Text(loc(context, "by_qr"))
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Divider(color: Colors.black.withOpacity(0.3), height: 1,),

                          Container(
                            width: double.infinity,
                            height: 60,
                            child: Material(
                              color: Colors.white.withOpacity(0.0),
                              child: InkWell(
                                onTap: () {

                                  setState(() {
                                    _showMethodChooser = false;
                                  });
                                  findFriends();
                                },
                                child: Row(
                                  children: [
                                    SizedBox(width: 20,),

                                    Icon(Icons.group),

                                    SizedBox(width: 10,),

                                    Text(loc(context, "find_friends"))
                                  ],
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ) : Container(),

          _isLoading? Loader(loadMessage: _loadMessage,) : Container()




        ],
      ),
    );
  }


  void selectReceiver() {
    setState(() {
      _showMethodChooser = true;
    });
  }


  void openQr () {

    Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner(
      onUserFound: (user, balance) {

        setState(() {
          _receiverUser = user;
          _targetWallet = balance;
        });
      },
    )));
  }
  
  
  void findFriends() {
    
  }

  void sendFunds() {
    var firestore = FirebaseFirestore.instance;



    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "performing_transaction")}..";

    });


    firestore.runTransaction((transaction) async{

      double amountToDecrease =  _finalAmount / (_fundsSource?.isFiat == false?(_fundsSourceExchange?.close as double) : (1.0/(_fundsSourceExchange?.close as double)));

      var mainBalanceRef = firestore.collection(AppDatabase.users).doc(userID)
      .collection(AppDatabase.balances).doc(_fundsSource?.id);

      var mainBalanceDoc = await transaction.get(mainBalanceRef);

      double currentBalance = double.parse(mainBalanceDoc.data()?[AppDatabase.amount].toString() as String);

      double newBalance = currentBalance - amountToDecrease;



      var receiverBalanceRef = firestore.collection(AppDatabase.users).doc(_receiverUser?.id)
      .collection(AppDatabase.balances).doc(_targetWallet?.id);

      var receiverBalanceDoc = await transaction.get(receiverBalanceRef);


      double amountToAdd = _finalAmount / (_targetWallet?.isFiat == false?(_receiverExchange?.close as double) : (1.0/(_receiverExchange?.close as double)));

      double receiverBalance = double.parse(receiverBalanceDoc.data()?[AppDatabase.amount].toString() as String);


      double newReceiverBalance = receiverBalance + amountToAdd;

      transaction.update(receiverBalanceRef, {
        AppDatabase.amount: newReceiverBalance
      });
      transaction.update(mainBalanceRef, {
        AppDatabase.amount: newBalance
      });

      var senderTransactionRef = firestore.collection(AppDatabase.users).doc(userID)
      .collection(AppDatabase.transactions).doc();

      var receiverTransactionRef = firestore.collection(AppDatabase.users).doc(_receiverUser?.id)
      .collection(AppDatabase.transactions).doc();

      transaction.set(senderTransactionRef, {
        AppDatabase.type: "send",
        AppDatabase.senderID: userID,
        AppDatabase.originBalance: _fundsSource?.id,
        AppDatabase.receiverID: _receiverUser?.id,
        AppDatabase.destinationBalance: _targetWallet?.id,
        AppDatabase.amount: amountToAdd,
        AppDatabase.created: DateTime.now()
      });


      transaction.set(receiverTransactionRef, {
        AppDatabase.type: "receive",
        AppDatabase.senderID: userID,
        AppDatabase.originBalance: _fundsSource?.id,
        AppDatabase.receiverID: _receiverUser?.id,
        AppDatabase.amount: amountToAdd,
        AppDatabase.destinationBalance: _targetWallet?.id,
        AppDatabase.created: DateTime.now()
      });




    }).then((value) async{

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: loc(context, "transaction_performed"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );



      double amountToAdd = _amount / (_targetWallet?.isFiat == false?(_receiverExchange?.close as double) : (1.0/(_receiverExchange?.close as double)));

      String title = "${currentUserData?.firstName} ${currentUserData?.lastName} te envió fondos";
      String content = "${amountToAdd} ${_targetWallet?.currencyCode?.substring(0, 3)} fueron agregaros a tu balance";

      firestore.collection(AppDatabase.users)
          .doc(_receiverUser?.id).collection(AppDatabase.notifications).doc().set({
        AppDatabase.title: title,
        AppDatabase.content: content,
        AppDatabase.seen: false,
        AppDatabase.created: DateTime.now()
      });


      try {
        var response = await Dio().post("https://cuidabu.herokuapp.com/sendNotification",data: {
          "receiver" : _receiverUser?.id,
          "title" : title,
          "content" : content
        });
        print("Notification sent!");


      }catch(e) {

        print("Error sending message: ${e.toString()}");

      }


      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => Home(currentScreen: 2,)
      ), (route) => false);


      Future.delayed(Duration(milliseconds: 200), () {

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => TransactionSuccess(
              receiverName: "${_receiverUser?.firstName} ${_receiverUser?.lastName}",
              receiverCurrency: "${_targetWallet?.currencyCode?.substring(0, 3)}",
              amount: amountToAdd,
            )
        ));

      });





    }).catchError((onError) {

      setState(() {
        _isLoading = false;
      });

      print("Error performing transaction: ${onError.toString()}");

    });


  }
  
 
}
