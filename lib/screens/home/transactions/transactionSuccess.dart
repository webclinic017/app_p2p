import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class TransactionSuccess extends StatefulWidget {

  String? receiverName;
  String? receiverCurrency;
  double? amount;

  TransactionSuccess({this.receiverName, this.receiverCurrency, this.amount});


  @override
  _TransactionSuccessState createState() => _TransactionSuccessState(
    receiverName: receiverName, receiverCurrency: receiverCurrency,
    amount: amount
  );
}

class _TransactionSuccessState extends State<TransactionSuccess> {

  String? receiverName;
  String? receiverCurrency;
  double? amount;

  _TransactionSuccessState({this.receiverName, this.receiverCurrency, this.amount});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [


            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [

                  Expanded(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.check_circle, size: 100,
                        color: AppColors.secondary,),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "funds_sent_successfully"),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text("${amount} ${receiverCurrency} ${loc(context, "were_added_to")} ${receiverName} ${loc(context, "account")}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                      color: AppColors.mediumGray),
                    textAlign: TextAlign.center,),
                  ),

                  SizedBox(height: 50,),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1, blurRadius: 4, offset: Offset(0,4))]
                    ),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(loc(context, "go_to_menu_uppercase"),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                color: Colors.white),),
                        )
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
