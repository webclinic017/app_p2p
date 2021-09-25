import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/components/notificationItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/notificationData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {

  Function()? onBack;
  Notifications({this.onBack});


  @override
  _NotificationsState createState() => _NotificationsState(onBack: onBack);
}

class _NotificationsState extends State<Notifications> {


  Function()? onBack;
  _NotificationsState({this.onBack});

  int _loadLimit = 20;
  DocumentSnapshot? _lastDoc;
  bool _renderState = false;

  List<Widget> _notifications = [];

  bool _loadingNotifications = false;

  @override
  void initState() {
    loadNotifications();
    super.initState();
  }

  void loadNotifications () {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingNotifications = true;
      _notifications.clear();
    });

    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.notifications)
        .orderBy(AppDatabase.created, descending: true).limit(_loadLimit).get().then((query) {

      for(var doc in query.docs) {
        NotificationData notificationData = NotificationData.fromDoc(doc);
        setState(() {
          _notifications.add(NotificationItem(data: notificationData,));
          _notifications.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _notifications.add(LoadMore(onLoad: () {

            loadMoreNotifications();
          },));
        });
      }

      setState(() {
        _loadingNotifications = false;
        _renderState = !_renderState;
      });

    }).catchError((onError) {

      setState(() {
        _loadingNotifications = false;
      });

      print("Error loading notifications: ${onError.toString()}");

    });
  }

  void loadMoreNotifications () {

    var firestore = FirebaseFirestore.instance;

    setState(() {

      _notifications.removeLast();
    });

    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.notifications)
        .orderBy(AppDatabase.created, descending: true)
        .startAfterDocument(_lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      for(var doc in query.docs) {
        NotificationData notificationData = NotificationData.fromDoc(doc);
        setState(() {
          _notifications.add(NotificationItem(data: notificationData,));
          _notifications.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }

      if(query.docs.length >= _loadLimit) {
        setState(() {
          _notifications.add(LoadMore(onLoad: () {

            loadMoreNotifications();
          },));
        });
      }
      setState(() {
        _renderState = !_renderState;
      });


    }).catchError((onError) {



      print("Error loading more notifications: ${onError.toString()}");

    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(loc(context, "notifications"),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: () {

          Navigator.pop(context);
          onBack?.call();

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),

      ),
      body: Stack(
        children: [

          Container(
              width: double.infinity,
              height: double.infinity,
              child: _loadingNotifications? Column(
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
              ) : Column(
                children: [
                  SizedBox(height: 20,),

                  Expanded(
                    child: (_renderState? SingleChildScrollView(
                      child: Column(
                        children: _notifications,
                      ),
                    ) : Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _notifications,
                        ),
                      ),
                    )),
                  ),
                ],
              )
          )

        ],
      ),
    ), onWillPop: () async {

      Navigator.pop(context);
      onBack?.call();

      return false;
    });
  }
}
