import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {


  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {



  double _totalUsd = 0.0;

  void updatingBalanceData() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.users).doc(userID).get().then((doc) {

      setState(() {
        currentUserData = UserData.fromDoc(doc);
      });

      calculatingUSDBalance();

    }).catchError((onError) {

    });

  }

  bool _loadingBalances = false;

  void calculatingUSDBalance() async{
    var firestore = FirebaseFirestore.instance;

    _totalUsd = 0.0;

    setState(() {
      _loadingBalances = true;
    });
    var query = await firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.balances).orderBy(AppDatabase.amount, descending: true).get();

    List<BalanceData> balances = [];
    for(var doc in query.docs) {
      BalanceData balanceData = BalanceData.fromDoc(doc);
      balances.add(balanceData);
      setState(() {
        _balances.add(BalanceItem(data: balanceData,));
      });
    }


    setState(() {
      _loadingBalances = false;
    });
    for(BalanceData balance in balances) {

      double amountInUsd = await getCurrencyInUSD(balance);

      _totalUsd += amountInUsd;


    }

    setState(() {

    });

  }

  Future<double> getCurrencyInUSD (BalanceData balance) async{
    var firestore = FirebaseFirestore.instance;

    var query = await firestore.collection(AppDatabase.recentExchangeRates)
        .where(AppDatabase.code, isEqualTo: balance.currencyCode).get();

    if(query.docs.length >= 0) {
      return ExchangeData.fromDoc(query.docs.first).close as double;
    }

    try {
      var response = await Dio().get("${AppDatabase.historicalDataEndPoint}${balance.currencyCode}?api_token=${AppDatabase.apiToken}${AppDatabase.historicalDataHeaders}");

      return ExchangeData.fromMap(response.data as Map<String, dynamic>).close as double;

    }catch(e) {
      return 0.0;
    }

  }


  List<Widget> _balances = [];



  @override
  void initState() {
    updatingBalanceData();

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
              color: AppColors.background
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: AppColors.lightBackground,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("\$", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.5)),),

                              SizedBox(width: 5,),

                              Text("${_totalUsd.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,
                                    color: Colors.white),)
                            ],
                          ),
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
                          color: Colors.white.withOpacity(0.5)),),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _loadingBalances? Column(
                      children: [



                      ],
                    ) : Column(
                      children: _balances,
                    ),
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
