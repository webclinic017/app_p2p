import 'package:app_p2p/components/friendItem.dart';
import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/friendData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {


  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {


  int _loadLimit = 20;
  DocumentSnapshot? _lastDoc;
  bool _renderState = false;

  List<Widget> _friends = [];


  bool _loadingFriends = false;


  void loadFriends() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingFriends = true;
    });
    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.friends)
        .orderBy(AppDatabase.created, descending: true).limit(_loadLimit).get().then((query) {

          setState(() {
            _friends.clear();
          });

      for(var doc in query.docs) {

        FriendData friendData = FriendData.fromDoc(doc);

        setState(() {
          _friends.add(FriendItem(data: friendData,));
          _friends.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _friends.add(LoadMore(onLoad: () {

            loadMoreFriends();

          },));
        });
      }

      setState(() {
        _renderState = !_renderState;
        _loadingFriends = false;
      });



    }).catchError((onError) {

      setState(() {
        _loadingFriends = false;
      });


      print("Error loading friends: ${onError.toString()}");
    });
  }


  void loadMoreFriends () {
    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.friends)
        .orderBy(AppDatabase.created, descending: true)
        .startAfterDocument(_lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      setState(() {
        _friends.removeLast();
      });

      for(var doc in query.docs) {

        FriendData friendData = FriendData.fromDoc(doc);

        setState(() {
          _friends.add(FriendItem(data: friendData,));
          _friends.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _friends.add(LoadMore(onLoad: () {

            loadMoreFriends();

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

  @override
  void initState() {
    loadFriends();
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
                          hintText: loc(context, "search_friends"),
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
                        searchFriends();
                      },
                    ),
                  ),

                  !_searchResult? IconButton(onPressed: () {

                    searchFriends();

                  }, icon: Icon(Icons.search)) : IconButton(onPressed: () {

                    loadFriends();
                  }, icon: Icon(Icons.clear))
                ],
              ),
            ),
          ),

          SizedBox(height: 20,),


          Expanded(
            child: _loadingFriends? Column(
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
            ) : (_friends.length > 0? (
            _renderState? SingleChildScrollView(
              child: Column(
                children: _friends,
              ),
            ) : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: _friends,
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
                    child: Text(loc(context, "there_are_no_friends_to_show"),
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

  void searchFriends() {
    setState(() {
      _searchResult = false;
    });
    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.friends)
        .where(AppDatabase.keywords, arrayContains: _searchQuery)
        .orderBy(AppDatabase.created, descending: true)
          .limit(_loadLimit).get().then((query) {

      setState(() {
        _friends.clear();
      });

      for(var doc in query.docs) {

        FriendData friendData = FriendData.fromDoc(doc);

        setState(() {
          _friends.add(FriendItem(data: friendData,));
          _friends.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _friends.add(LoadMore(onLoad: () {

            searchMoreFriends();

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



  void searchMoreFriends () {
    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.friends)
        .orderBy(AppDatabase.created, descending: true)
        .where(AppDatabase.keywords, arrayContains: _searchQuery)
        .startAfterDocument(_lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      setState(() {
        _friends.removeLast();
      });

      for(var doc in query.docs) {

        FriendData friendData = FriendData.fromDoc(doc);

        setState(() {
          _friends.add(FriendItem(data: friendData,));
          _friends.add(SizedBox(height: 10,));
        });

        _lastDoc = doc;
      }


      if(query.docs.length >= _loadLimit) {
        setState(() {

          _friends.add(LoadMore(onLoad: () {

            loadMoreFriends();

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













