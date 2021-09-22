import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/exchangeData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFundsBalance extends StatefulWidget {


  Function(BalanceData, ExchangeData)? onSelected;
  Function()? onBack;

  AddFundsBalance({this.onSelected, this.onBack});


  @override
  _AddFundsBalanceState createState() => _AddFundsBalanceState(onSelected: onSelected,
  onBack: onBack);
}

class _AddFundsBalanceState extends State<AddFundsBalance> {

  Function(BalanceData, ExchangeData)? onSelected;
  Function()? onBack;
  _AddFundsBalanceState({this.onSelected, this.onBack});

  @override
  void initState() {
    loadBalances();
    super.initState();
  }

  List<Widget> _balances = [];

  int _loadLimit = 20;
  bool _loadingBalances = false;
  DocumentSnapshot? _lastDoc;

  bool _renderState = false;

  void loadBalances() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingBalances = true;
    });

    firestore.collection(AppDatabase.users).doc(userID).collection(AppDatabase.balances)
    .orderBy(AppDatabase.created, descending: true).limit(_loadLimit).get().then((query) {

      setState(() {
        _balances.clear();
      });

      for(var doc in query.docs) {

        BalanceData balanceData = BalanceData.fromDoc(doc);

        setState(() {
          _balances.add(BalanceItem(data: balanceData, onPressed: (data, exchange) {


            onSelected?.call(data, exchange);
          },));
          _balances.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _balances.add(LoadMore(onLoad: () {

            loadMoreBalances();
          },));
        });
      }

      setState(() {
        _loadingBalances = false;
        _renderState = !_renderState;
      });

    }).catchError((onError) {

      setState(() {
        _loadingBalances = false;
      });

      print("Error loading balances: ${onError.toString()}");
    });

  }

  void loadMoreBalances () {
    var firestore = FirebaseFirestore.instance;


    firestore.collection(AppDatabase.users).doc(userID).collection(AppDatabase.balances)
        .orderBy(AppDatabase.created, descending: true).startAfterDocument(_lastDoc as DocumentSnapshot)
        .limit(_loadLimit).get().then((query) {

      setState(() {
        _balances.removeLast();
      });

      for(var doc in query.docs) {

        BalanceData balanceData = BalanceData.fromDoc(doc);

        setState(() {
          _balances.add(BalanceItem(data: balanceData, onPressed: (data, exchange) {
            onSelected?.call(data, exchange);
          },));
          _balances.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _balances.add(LoadMore(onLoad: () {

            loadMoreBalances();
          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
      });



    }).catchError((onError) {



      print("Error loading more balances: ${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [



        Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [

              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(loc(context, "balance_uppercase"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              ),

              SizedBox(height: 10,),

              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(loc(context, "select_the_balance_where_do_you_want_to_add_money"),
                style: TextStyle(color: AppColors.mediumGray, fontWeight: FontWeight.w600),),
              ),

              SizedBox(height: 30,),

              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                  ) : (_renderState? SingleChildScrollView(
                    child: Column(
                      children: _balances,
                    ),
                  ) : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _balances,
                      ),
                    ),
                  )) ,
                )
              ),

              SizedBox(height: 20,),

              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      child: Material(
                        color: Colors.white.withOpacity(0.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            onBack?.call();
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text(loc(context, "previous"),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                              color: AppColors.secondary),),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        )
      ],
    );
  }
}














