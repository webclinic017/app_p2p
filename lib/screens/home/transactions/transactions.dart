import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/transactionData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/transactions/components/transactionItem.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {


  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {


  bool _loadingTransactions = false;
  int _loadLimit = 20;
  DocumentSnapshot? _lastDoc;

  List<Widget> _transactions = [];

  bool _renderState = false;

  void loadTransactions() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingTransactions = true;
    });

    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.transactions).orderBy(AppDatabase.created)
    .limit(_loadLimit).get().then((query) {

      setState(() {

        _transactions.clear();
      });

      for(var doc in query.docs) {

        TransactionData transactionData = TransactionData.fromDoc(doc);

        setState(() {
         _transactions.add(TransactionItem(data: transactionData,));
         _transactions.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _transactions.add(LoadMore(onLoad: () {

            loadMoreTransactions();

          },));
        });
      }

      setState(() {
        _loadingTransactions = false;
        _renderState = !_renderState;
      });
    }).catchError((onError) {
      setState(() {
        _loadingTransactions = false;
      });

      print("Error loading transactions: ${onError.toString()}");
    });
  }


  void loadMoreTransactions () {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingTransactions = true;
    });

    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.transactions).orderBy(AppDatabase.created)
        .startAfterDocument(_lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      setState(() {

        _transactions.removeLast();
      });

      for(var doc in query.docs) {

        TransactionData transactionData = TransactionData.fromDoc(doc);

        setState(() {
          _transactions.add(TransactionItem(data: transactionData,));
          _transactions.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _transactions.add(LoadMore(onLoad: () {

            loadMoreTransactions();

          },));
        });
      }
      setState(() {
        _renderState = !_renderState;
      });


    }).catchError((onError) {

      print("Error loading transactions: ${onError.toString()}");
    });
  }

  @override
  void initState() {
   loadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "transactions"),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: Stack(
        children: [


          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20,),

                Expanded(
                  child: _loadingTransactions? Column(
                    children: [

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
                  ) : (_transactions.length > 0?(_renderState ? SingleChildScrollView(child: Column(
                    children: _transactions,
                  ),) : Container(
                    child: SingleChildScrollView(child: Column(
                      children: _transactions,
                    ),),
                  )) : Column(
                    children: [

                      SizedBox(height: 20,),

                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(loc(context, "no_transactions_yet"),
                        style: TextStyle(color: AppColors.mediumGray,
                        fontWeight: FontWeight.w600, fontSize: 16),
                        textAlign: TextAlign.center,),
                      ),

                      SizedBox(height: 30,),

                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset("assets/no_transactions.png",
                              width: 200, height: 200, ),
                          )
                        ),
                      )
                    ],
                  )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
