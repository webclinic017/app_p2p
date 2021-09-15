import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/currenciesColors.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BalanceItem extends StatefulWidget {

  BalanceData? data;
  bool? isFiat;
  bool? isMine;
  Function(BalanceData)? onPressed;
  BalanceItem({this.data, this.isFiat, this.isMine, this.onPressed});


  @override
  _BalanceItemState createState() => _BalanceItemState(data: data, isFiat: isFiat, isMine: isMine, onPressed: onPressed);
}

class _BalanceItemState extends State<BalanceItem> {

  BalanceData? data;
  bool? isFiat;
  bool? isMine;
  Function(BalanceData)? onPressed;
  _BalanceItemState({this.data, this.isFiat, this.isMine, this.onPressed}) {
    if(isFiat == null) {
      isFiat = false;
    }

    if(isMine == null) {
      isMine = false;
    }
  }

  Color? _currencyC;
  Color get currencyColor {

    //print("CurrencyCode: ${data?.currencyCode}");

    if(_currencyC == null) {
      _currencyC = CurrenciesColors.getCurrencyColor(data?.currencyCode as String);
      return _currencyC as Color;
    }
    return _currencyC as Color;
  }



  ExchangeData? _currencyExchangeData;
  void currentExchangeData() async {
    var firestore = FirebaseFirestore.instance;

    var query = await firestore.collection(AppDatabase.recentExchangeRates)
        .where(AppDatabase.code, isEqualTo: "${data?.currencyCode}").get();

   // print("Docs length: ${query.docs.length}");

    if(query.docs.length > 0) {
      for (var doc in query.docs) {
        ExchangeData exchangeData = ExchangeData.fromDoc(doc);

        if (DateTime.now().difference(exchangeData.time as DateTime) <
            Duration(minutes: 30)) {
          setState(() {
            _currencyExchangeData = exchangeData;
          });
          //print("DATA TAKEN FROM FIREBASE");
        } else {
          //print("MORE THAN 30 MINUTES HAS BEEN PASSED");
          registerExchange(doc.id);
        }
      }
    }else {
      registerExchange(null);
    }
  }

  void registerExchange (String? exchangeID) async{
    var firestore = FirebaseFirestore.instance;


    try {
      var response = await Dio().get(
          "${AppDatabase.historicalDataEndPoint}${data
              ?.currencyCode}?api_token=${AppDatabase.apiToken}${AppDatabase
              .historicalDataHeaders}");

   //   print("REQUEST PERFORMED TO API");

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

      setState(() {
        _currencyExchangeData = newExchangeData;
      });
    }on DioError catch (e) {

      print("Error: ${e.response?.data}");
    }



  }

  @override
  void initState() {

    currentExchangeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        border: Border.all(color: AppColors.secondary.withOpacity(isMine == true? 1.0 : 0.0), width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed?.call(data as BalanceData),
          child: Row(
            children: [
              SizedBox(width: 20,),

              Container(
                width: 60,
                height: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: currencyColor ,
                        shape: BoxShape.circle,

                      ),
                      child: isFiat == false?Align(
                        alignment: Alignment.center,
                        child: Text(data?.currencyName?[0].toUpperCase() as String,
                        style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w600),),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CurrenciesManager.getFlag(data?.currencyCode as String)
                      ),
                    ),


                  ],
                ),
              ),

              SizedBox(width: 5,),

              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        width: double.infinity,
                        height: 20,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Text(data?.currencyCode as String, style: TextStyle(fontWeight: FontWeight.w600,
                                    color: Colors.white),),

                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(data?.amount?.toStringAsFixed(8) as String, style: TextStyle(fontWeight: FontWeight.w600,
                                    color: Colors.white),),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),



                      Container(
                        width: double.infinity,
                        height: 15,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(isFiat == false? (data?.currencyName as String) : loc(context, data?.currencyName as String), style: TextStyle(fontSize: 12,
                                          color: Colors.white.withOpacity(0.5)),),

                                    ],
                                  ),
                                )
                              ),
                            ),

                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(_currencyExchangeData != null? "\$ ${((_currencyExchangeData?.close as double) * (data?.amount as double)).toStringAsFixed(4)}" : "-", style: TextStyle(fontSize: 14,
                                    color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w800),),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Divider(color: Colors.white.withOpacity(0.4), height: 10,),



                      Container(
                        width: double.infinity,
                        height: 20,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 100,
                                    height: 15,
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Text(_currencyExchangeData != null? "1 ${data?.currencyCode?.substring(0,3)} = ${(_currencyExchangeData?.close?.toStringAsFixed(2) as String) } B-Dollar": "-", style: TextStyle(
                                          color: Colors.white.withOpacity(0.7), fontSize: 12),),
                                    ),
                                  ),
                                )
                              ),
                            ),

                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(_currencyExchangeData != null? "${(_currencyExchangeData?.changeP as double) >= 0? "+" : ""}${_currencyExchangeData?.changeP?.toStringAsFixed(2)}%" : "-", style: TextStyle(

                                        color: Colors.green.withOpacity(0.7), fontSize: 12),),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),







                    ],
                  ),
                ),
              ),


              SizedBox(width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
