import 'package:app_p2p/components/friendItem.dart';
import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/components/simpleUserItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/friendData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/conversationScreen.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NearbyScreen extends StatefulWidget {


  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {

  int _loadLimit = 20;
  DocumentSnapshot? _lastDoc;
  bool _renderState = false;

  List<Widget> _nearbyUsers = [];


  bool _loadingNearbyUsers = false;

  double maxKm = 15.0;


  bool _isLoading = false;
  String _loadMessage = "";



  void loadNearbyUsers() {
    var firestore = FirebaseFirestore.instance;

    if(currentUserData?.position == null) {
      return;
    }

    double minLat = (currentUserData?.position?.latitude as double) - ((maxKm/2.0)/111.0);
    double maxLat = (currentUserData?.position?.latitude as double) + ((maxKm/2.0)/111.0);
    double minLng = (currentUserData?.position?.longitude as double) - ((maxKm/2.0)/111.0);
    double maxLng = (currentUserData?.position?.longitude as double) + ((maxKm/2.0)/111.0);

    GeoPoint lesserGeopoint = GeoPoint(minLat, minLng);
    GeoPoint greaterGeopoint = GeoPoint(maxLat, maxLng);

    print("Min lat: ${minLat}, Max lat: ${maxLat}");

    setState(() {
      _loadingNearbyUsers = true;
    });
    firestore.collection(AppDatabase.users)
          .where(AppDatabase.currentPosition, isGreaterThan: lesserGeopoint)
        .where(AppDatabase.currentPosition, isLessThan: greaterGeopoint )
    .orderBy(AppDatabase.currentPosition, descending: true)

       .limit(_loadLimit).get().then((query) {

      setState(() {
        _nearbyUsers.clear();
      });

      for(var doc in query.docs) {

        if(doc.id == userID) {
          continue;
        }

        UserData userData =  UserData.fromDoc(doc);

        setState(() {
          _nearbyUsers.add(SimpleUserItem(data: userData, onPressed: (data) {
            checkingChats(data);
          },));
          _nearbyUsers.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _nearbyUsers.add(LoadMore(onLoad: () {

            loadMoreNearbyUsers();

          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
        _loadingNearbyUsers = false;
      });



    }).catchError((onError) {

      setState(() {
        _loadingNearbyUsers = false;
      });


      print("Error loading friends: ${onError.toString()}");
    });
  }


  void loadMoreNearbyUsers() {
    var firestore = FirebaseFirestore.instance;

    if(currentUserData?.position == null) {
      return;
    }

    double minLat = (currentUserData?.position?.latitude as double) - ((maxKm/2.0)/111.0);
    double maxLat = (currentUserData?.position?.latitude as double) + ((maxKm/2.0)/111.0);
    double minLng = (currentUserData?.position?.longitude as double) - ((maxKm/2.0)/111.0);
    double maxLng = (currentUserData?.position?.longitude as double) + ((maxKm/2.0)/111.0);

    GeoPoint lesserGeopoint = GeoPoint(minLat, minLng);
    GeoPoint greaterGeopoint = GeoPoint(maxLat, maxLng);

    print("Min lat: ${minLat}, Max lat: ${maxLat}");

    setState(() {
      _loadingNearbyUsers = true;
    });
    firestore.collection(AppDatabase.users)
        .where(AppDatabase.currentPosition, isGreaterThan: lesserGeopoint)
        .where(AppDatabase.currentPosition, isLessThan: greaterGeopoint )
        .orderBy(AppDatabase.currentPosition, descending: true)

        .limit(_loadLimit).get().then((query) {

      setState(() {
        _nearbyUsers.clear();
      });

      for(var doc in query.docs) {

        if(doc.id == userID) {
          continue;
        }

        UserData userData =  UserData.fromDoc(doc);

        setState(() {
          _nearbyUsers.add(SimpleUserItem(data: userData,));
          _nearbyUsers.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _nearbyUsers.add(LoadMore(onLoad: () {

            loadMoreNearbyUsers();

          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
        _loadingNearbyUsers = false;
      });



    }).catchError((onError) {

      setState(() {
        _loadingNearbyUsers = false;
      });


      print("Error loading friends: ${onError.toString()}");
    });
  }




  void checkingChats(UserData data) {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "opening_chat")}..";
    });

    firestore.collection(AppDatabase.chats)
    .where(AppDatabase.involvedCode, arrayContainsAny: [
      "${userID}-${data.id}", "${data.id}-${userID}"
    ]).get().then((query) {

      if(query.docs.length <= 0) {
        createChat(data);
        setState(() {
          _isLoading = false;
        });
        return;
      }



      ChatData chatData = ChatData.fromDoc(query.docs.first);

      openChat(chatData);


    }).catchError((onError) {

      setState(() {
        _isLoading = false;
      });

      print("Error getting chat: ${onError.toString()}");

    });




  }


  void createChat (UserData data) {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context,  "creating_chat")}..";
    });

    firestore.collection(AppDatabase.chats).add({
      AppDatabase.involvedCode: "${userID}"
    });
  }

  void openChat(ChatData chatData) {

    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(
      data: chatData,
    )));

  }

  @override
  void initState() {
    loadNearbyUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [

          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: loc(context, "search_users"),
                          hintStyle: TextStyle(color: AppColors.mediumGray)
                      ),
                      onChanged: (value) {

                        _searchQuery = value;
                        setState(() {
                          _searchResult = false;
                        });

                      },
                      onFieldSubmitted: (value) {
                        _searchQuery = value;
                        searchNearbyFriends();
                      },
                    ),
                  ),

                  !_searchResult? IconButton(onPressed: () {

                    searchNearbyFriends();

                  }, icon: Icon(Icons.search)) : IconButton(onPressed: () {

                    loadMoreNearbyUsers();
                  }, icon: Icon(Icons.clear))
                ],
              ),
            ),
          ),

          SizedBox(height: 20,),


          Expanded(
            child: _loadingNearbyUsers? Column(
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
            ) : (_nearbyUsers.length > 0? (
                _renderState? SingleChildScrollView(
                  child: Column(
                    children: _nearbyUsers,
                  ),
                ) : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _nearbyUsers,
                    ),
                  ),
                )
            ) : Column(
              children: [

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(loc(context, "there_are_no_users_to_show"),
                      style: TextStyle(color: AppColors.mediumGray,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,),
                  ),
                )

              ],
            )),
          )


        ],
      ),
    );
  }

  String? _searchQuery;
  bool _searchResult = false;

  void searchNearbyFriends() {
    var firestore = FirebaseFirestore.instance;

    if(currentUserData?.position == null) {
      return;
    }

    setState(() {
      _searchResult = false;
    });

    double minLat = (currentUserData?.position?.latitude as double) - ((maxKm/2.0)/111.0);
    double maxLat = (currentUserData?.position?.latitude as double) + ((maxKm/2.0)/111.0);
    double minLng = (currentUserData?.position?.longitude as double) - ((maxKm/2.0)/111.0);
    double maxLng = (currentUserData?.position?.longitude as double) + ((maxKm/2.0)/111.0);

    GeoPoint lesserGeopoint = GeoPoint(minLat, minLng);
    GeoPoint greaterGeopoint = GeoPoint(maxLat, maxLng);

    print("Min lat: ${minLat}, Max lat: ${maxLat}");

    firestore.collection(AppDatabase.users)
        .where(AppDatabase.currentPosition, isGreaterThan: lesserGeopoint)
        .where(AppDatabase.currentPosition, isLessThan: greaterGeopoint )
        .orderBy(AppDatabase.currentPosition, descending: true)
        .where(AppDatabase.keywords, arrayContains: _searchQuery)
        .limit(_loadLimit).get().then((query) {

      setState(() {
        _nearbyUsers.clear();
      });

      for(var doc in query.docs) {

        if(doc.id == userID) {
          continue;
        }

        UserData userData =  UserData.fromDoc(doc);

        setState(() {
          _nearbyUsers.add(SimpleUserItem(data: userData,));
          _nearbyUsers.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _nearbyUsers.add(LoadMore(onLoad: () {

            loadMoreNearbyUsers();

          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
        _searchResult = true;
      });



    }).catchError((onError) {



      print("Error loading friends: ${onError.toString()}");
    });

  }



  void searchMoreNearbyFriends () {
    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users)
        .orderBy(AppDatabase.created, descending: true)
        .where(AppDatabase.keywords, arrayContains: _searchQuery)
        .startAfterDocument(_lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      setState(() {
        _nearbyUsers.removeLast();
      });

      for(var doc in query.docs) {

        if(doc.id == userID) {
          continue;
        }

        FriendData friendData = FriendData.fromDoc(doc);

        setState(() {
          _nearbyUsers.add(FriendItem(data: friendData,));
          _nearbyUsers.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _nearbyUsers.add(LoadMore(onLoad: () {

            loadMoreNearbyUsers();

          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
      });



    }).catchError((onError) {


      print("Error loading friends: ${onError.toString()}");
    });
  }
}
