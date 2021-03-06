import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/wallet/convertBalance.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:app_p2p/utilities/currenciesManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayBalance extends StatefulWidget {

  BalanceData? data;
  ExchangeData? exchangeData;
  Function()? onBalanceOpened;
  
  DisplayBalance({this.data, this.exchangeData, this.onBalanceOpened});

  @override
  _DisplayBalanceState createState() => _DisplayBalanceState(data: data,
  exchangeData: exchangeData, onBalanceOpened: onBalanceOpened);
}

class _DisplayBalanceState extends State<DisplayBalance> {

  BalanceData? data;
  ExchangeData? exchangeData;
  Function()? onBalanceOpened;
  _DisplayBalanceState({this.data, this.exchangeData, this.onBalanceOpened});
  
  bool _isLoading = false;
  String _loadMessage = "";

  bool _checking = false;
  bool _inBalance = false;
  void checkIfIsInBalances() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _checking = true;
    });
    
    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.balances).where(AppDatabase.currencyCode, isEqualTo: data?.currencyCode)
    .get().then((query) {

      if(query.docs.length > 0) {
        setState(() {
          data = BalanceData.fromDoc(query.docs.first);
          _inBalance = true;
        });
      }
      setState(() {
        _checking = false;
      });

    }).catchError((onError) {

      setState(() {
        _checking = false;
      });
      print("Error checking currency is in balance: ${onError.toString()}");

    });
  }

  @override
  void initState() {
    checkIfIsInBalances();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(data?.currencyName as String,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
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
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    height: 100,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppColors.form,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: data?.isFiat == true? CurrenciesManager.getFlag(data?.currencyCode as String) :
                            Align(
                              alignment: Alignment.center,
                              child: Text(data?.currencyCode?[0].toUpperCase() as String,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              _inBalance? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                                ),
                                child: Material(
                                  color: Colors.white.withOpacity(0.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(40),
                                    onTap: () {

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ConvertBalance(
                                        from: data,
                                      )));

                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.wifi_protected_setup, color: Colors.white,),
                                    ),
                                  ),
                                ),
                              ) : Container()

                            ],
                          ),
                        )
                      ],
                    )
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    child: Text(data?.currencyCode as String,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: Colors.black),
                    textAlign: TextAlign.center,),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(exchangeData != null? "1 B-Dollar = ${(exchangeData?.close?.toStringAsFixed(2) as String) } ${data?.currencyCode?.substring(0,3)}": "-", style: TextStyle(
                            color: Colors.black.withOpacity(0.7), fontSize: 14),),


                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(exchangeData != null? "${(exchangeData?.changeP as double) >= 0? "+" : ""}${exchangeData?.changeP?.toStringAsFixed(2)}%" : "-", style: TextStyle(

                        color: Colors.green.withOpacity(0.7), fontSize: 14),
                    textAlign: TextAlign.center,),
                  ),

                  SizedBox(height: 30,),

                  _checking? Container(
                    width: double.infinity,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),),
                      ),
                    ),
                  ) : (_inBalance? Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),

                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondary
                          ),
                        ),
                        SizedBox(width: 10,),

                        Text("${data?.amount?.toStringAsFixed(8)} ${data?.currencyCode?.substring(0, 3)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
                              color: AppColors.secondary),),
                      ],
                    )
                  ) : Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
                            spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
                    ),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {

                         AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
                         content: "${loc(context, "do_you_want_to_open_a_new")} ${data?.currencyCode?.substring(0,3)} ${loc(context, "balance_lowercase")}" ,
                         actions: [loc(context, "cancel_uppercase"), loc(context, "yes_uppercase")],
                         callbacks: [() {

                           Navigator.pop(context);
                         }, () {
                           Navigator.pop(context);
                           openBalance();
                         }]);

                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(loc(context, "open_balance_uppercase"),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                          color: Colors.white),),
                        ),
                      ),
                    ),
                  )),

                  _inBalance? SizedBox(height: 10,) : Container(),

                  _inBalance? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(loc(context, "in_b_dollars"),
                    style: TextStyle(color: Colors.white.withOpacity(0.4),
                    fontSize: 12),),
                  ) : Container(),

                  _inBalance? SizedBox(height: 2,) : Container(),

                  _inBalance? Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text("\$ ${(data?.amount as double) * (exchangeData?.close as double)}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.7)),),
                      ),
                    ),
                  ) : Container()
                  
                  



                ],
              ),
            ),
          ),

          _isLoading? Loader(loadMessage: _loadMessage,) : Container()


        ],
      ),
    );
  }


  bool _openingBalance = false;
  void openBalance() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _openingBalance = true;
      _isLoading = true;
      _loadMessage = "${loc(context, "opening_balance")}..";
    });

    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.balances).add(data?.toMap() as Map<String, dynamic>)
    .then((result) {

      setState(() {
        _openingBalance = false;
        _isLoading = false;
      });

      onBalanceOpened?.call();

      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: loc(context, "balance_opened"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

    }).catchError((onError) {

      setState(() {
        _openingBalance = false;
        _isLoading = false;
      });
      print("Error opening balance: ${onError.toString()}");
    });
  }
}
