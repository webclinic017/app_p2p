import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/chatsScreen.dart';
import 'package:app_p2p/screens/home/profile/profile.dart';
import 'package:app_p2p/screens/home/social/social.dart';
import 'package:app_p2p/screens/home/wallet/wallet.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {

  int? currentScreen;
  Home({this.currentScreen = 0});

  @override
  _HomeState createState() => _HomeState(currentScreen: currentScreen);
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  int? currentScreen;
  _HomeState({this.currentScreen});

  PageController _pageController = PageController();
  TabController? _tabController;

  int _selectedScreen = 0;
  Position? _currentPosition;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    setState(() {
      _selectedScreen = currentScreen as int;
    });
    loadCurrentLocation();
    super.initState();
  }

  void loadCurrentLocation() async{

    bool? serviceEnabled = false;
    LocationPermission? permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) {
      Fluttertoast.showToast(
          msg: loc(context, "location_services_are_disabled"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: loc(context, "location_permissions_are_denied"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white.withOpacity(0.8),
            fontSize: 16.0
        );
        return;
      }

    }

    if(permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: loc(context, "location_permissions_are_denied_forever"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();

    updatePosition(_currentPosition);


  }

  bool _updatingPosition = false;
  void updatePosition(Position? position) {
    var firestore = FirebaseFirestore.instance;


    print("UserID: ${userID}");
    setState(() {
      _updatingPosition = true;
    });
    firestore.collection(AppDatabase.users).doc(userID).update({
      AppDatabase.currentPosition: GeoPoint(position?.latitude as double,
        position?.longitude as double)
    }).then((result) {

      setState(() {
        _updatingPosition = false;
      });

      print("Position updated!");

    }).catchError((onError) {

      setState(() {
        _updatingPosition = false;
      });

      print("Error updating position: ${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,

        leading: IconButton(onPressed: () {

          AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
              content: loc(context, "do_you_want_to_logout"),
              actions: [loc(context, "cancel_uppercase"),
                loc(context, "yes_uppercase")],
              callbacks: [() {

                Navigator.pop(context);

              }, () {
                Navigator.pop(context);
                logout();
              }]);

        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: Text(loc(context, "profile"),),
            value: "profile",)
          ],
          onSelected: (value) {

            if(value  == "profile") {

              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            }
          },)
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



            Text(currentUserData != null? "${currentUserData?.firstName} ${currentUserData?.lastName}" : "", style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 20),),
          ],
        ),
        centerTitle: true,

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary,
          onTap: (index) {
            setState(() {
              _selectedScreen = index;
            });
            _pageController.animateToPage(_selectedScreen,
                duration: Duration(milliseconds: 300), curve: Curves.ease);

          },
          tabs: [
            Tab(text: loc(context, "chats"), icon: Icon(Icons.message),),
            Tab(text: loc(context, "wallet"), icon: Icon(Icons.account_balance_wallet),),
            Tab(text: loc(context, "social"), icon: Icon(Icons.group),),
          ],
        ),

      ),
      body: Stack(
        children: [

          Container(
              width: double.infinity,
              height: double.infinity,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [

                  ChatsScreen(),
                  Wallet(),
                  Social()

                ],
              )
          )

        ],
      ),
    ), onWillPop: () async{

      AppUtilities.displayDialog(context, title: loc(context, "are_u_sure"),
      content: loc(context, "do_you_want_to_logout"),
      actions: [loc(context, "cancel_uppercase"),
      loc(context, "yes_uppercase")],
      callbacks: [() {

        Navigator.pop(context);

      }, () {

        Navigator.pop(context);
        logout();
      }]);



      return false;
    });
  }


  void logout() {
    var auth = FirebaseAuth.instance;

    auth.signOut().then((result) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);

    }).catchError((onError) {

      print("Error loging out: ${onError.toString()}");
    });


  }
}
