import 'package:app_p2p/components/balanceItem.dart';
import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BalancePicker extends StatefulWidget {

  Function(BalanceData)? onBalanceSelected;
  BalancePicker({this.onBalanceSelected});

  @override
  _BalancePickerState createState() => _BalancePickerState(
    onBalanceSelected: onBalanceSelected
  );
}

class _BalancePickerState extends State<BalancePicker> {

  Function(BalanceData)? onBalanceSelected;
  _BalancePickerState({this.onBalanceSelected});


  List<Widget> _balances = [];
  int _loadLimit = 20;
  DocumentSnapshot? _lastDoc;
  bool _loadingBalances = false;

  void loadBalances() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingBalances = true;
    });

    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.balances).orderBy(AppDatabase.created, descending: true)
    .limit(_loadLimit).get().then((query) {

      setState(() {
        _balances.clear();
      });

      for(var doc in query.docs) {

        BalanceData data = BalanceData.fromDoc(doc);

        setState(() {
          _balances.add(BalanceItem(data: data, onPressed: (data, exchange) {

            onBalanceSelected?.call(data);
            Navigator.pop(context);

          },));
          _balances.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;

      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _balances.add(LoadMore(onLoad: () {
            loadMoreBalance();
          },));
        });
      }

      setState(() {
        _loadingBalances = false;
      });


    }).catchError((onError) {

      setState(() {
        _loadingBalances = false;
      });

      print("Error loading balances: ${onError.toString()}");
    });

  }


  void loadMoreBalance() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.balances).orderBy(AppDatabase.created, descending: true)
    .startAfterDocument(_lastDoc as DocumentSnapshot)
        .limit(_loadLimit).get().then((query) {

      setState(() {
        _balances.removeLast();
      });

      for(var doc in query.docs) {

        BalanceData data = BalanceData.fromDoc(doc);

        setState(() {
          _balances.add(BalanceItem(data: data, onPressed: (data, exchange) {

            onBalanceSelected?.call(data);

            Navigator.pop(context);

          },));
          _balances.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;

      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _balances.add(LoadMore(onLoad: () {

            loadMoreBalance();
          },));
        });
      }


    }).catchError((onError) {


      print("Error loading balances: ${onError.toString()}");
    });
  }

  @override
  void initState() {
    loadBalances();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "balance_picker"),
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
            child: _loadingBalances? Column(
              children: [

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
                    ),
                  ),
                )

              ],
            ) : Column(
              children: [
                SizedBox(height: 40,),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _balances,
                      ),
                    ),
                  )
                )
              ],
            )
          )



        ],
      ),
    );
  }
}
