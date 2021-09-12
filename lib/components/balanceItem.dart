import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/currenciesColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BalanceItem extends StatefulWidget {

  BalanceData? data;
  BalanceItem({this.data});


  @override
  _BalanceItemState createState() => _BalanceItemState(data: data);
}

class _BalanceItemState extends State<BalanceItem> {

  BalanceData? data;
  _BalanceItemState({this.data});

  Color? _currencyC;
  Color get currencyColor {

    if(_currencyC == null) {
      _currencyC = CurrenciesColors.getCurrencyColor(data?.currencyCode as String);
      return _currencyC as Color;
    }
    return _currencyC as Color;
  }



  ExchangeData? _currencyExchangeData;
  Future<ExchangeData> currentExchangeData() async {
    var firestore = FirebaseFirestore.instance;

    var query = await firestore.collection(AppDatabase.recentExchangeRates)
        .where(AppDatabase.code, isEqualTo: "${data?.currencyCode}.CC").get();

    if(query.docs.length > 0) {
      for (var doc in query.docs) {
        ExchangeData exchangeData = ExchangeData.fromDoc(doc);

        if (DateTime.now().difference(exchangeData.time as DateTime) <
            Duration(minutes: 10)) {
          setState(() {
            _currencyExchangeData = exchangeData;
          });
        } else {
          registerExchange(exchangeID: doc.id);
        }
      }
    }else {
      registerExchange();
    }
  }

  void registerExchange ({exchangeID: String}) async{
    var firestore = FirebaseFirestore.instance;

    try {
      var response = await Dio().get("${AppDatabase.historicalDataEndPoint}${data?.currencyCode}?api_token=${AppDatabase.apiToken}${AppDatabase.historicalDataHeaders}");

      ExchangeData newExchangeData = ExchangeData.fromMap(response.data as Map<String, dynamic>);



      if(exchangeID != null) {
        await firestore.collection(AppDatabase.recentExchangeRates).doc(exchangeID)
            .update(newExchangeData.toMap());
      }

    }catch(e) {


    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              SizedBox(width: 20,),

              Container(
                width: 60,
                height: double.infinity,
                child: Column(
                  children: [

                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: currencyColor ,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: currencyColor.withOpacity(0.4),
                        spreadRadius: 1, blurRadius: 4, offset: Offset(0, 4))]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(data?.currencyName?[0].toUpperCase() as String,
                        style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w600),),
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
                                child: Row(
                                  children: [
                                    Text(data?.currencyCode as String, style: TextStyle(fontSize: 12,
                                    color: Colors.white.withOpacity(0.5)),),

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
                                    Text(data?.amount?.toStringAsFixed(8) as String, style: TextStyle(fontSize: 12,
                                    color: Colors.white.withOpacity(0.5)),),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),


                      Divider(color: Colors.white.withOpacity(0.4),),

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
