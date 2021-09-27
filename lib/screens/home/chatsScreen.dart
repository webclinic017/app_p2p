import 'package:app_p2p/components/button.dart';
import 'package:app_p2p/components/chatItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/localDatabase/localDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/bluetooth/bluetoothScanner.dart';
import 'package:app_p2p/screens/home/conversationScreen.dart';
import 'package:app_p2p/screens/home/newChat.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {

  Function(int)? onUnreadMessages;

  ChatsScreen({this.onUnreadMessages});


  @override
  _ChatsScreenState createState() => _ChatsScreenState(onUnreadMessages: onUnreadMessages);
}

class _ChatsScreenState extends State<ChatsScreen> {

  Function(int)? onUnreadMessages;

  _ChatsScreenState({this.onUnreadMessages});


  int _loadLimit = 20;
  List<Widget> _chats = [];

  bool _loadingChats = false;
  bool renderState = false;

  int _unreadMessages = 0;

  void loadChats() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _loadingChats = true;
      _unreadMessages = 0;
    });

    firestore.collection(AppDatabase.chats).where(
      AppDatabase.involved, arrayContains: userID
    ).orderBy(AppDatabase.updated, descending: true).limit(_loadLimit).snapshots().listen((event) {

      setState(() {
        _chats.clear();
        _chats.add(SizedBox(height: 20,));
      });

      setState(() {
        _chats.add(Button(width: double.infinity, height: 50,
        color: AppColors.secondary,
        text: loc(context, "find_devices_uppercase"),
        margin: 20,
        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
          BluetoothScanner()));
        },),);

        setState(() {
          _chats.add(SizedBox(height: 10,));
        });
      });

      for(var doc in event.docs) {
        ChatData chatData = ChatData.fromDoc(doc);

        setState(() {
          _chats.add(ChatItem(data: chatData, onPressed: (data) {

            Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(data: data,
            onBack: () {

              loadChats();
            }, )));

          }, onUnreadMessages: (value) {
            setState(() {
              _unreadMessages += value;
            });
          }, ));
          _chats.add(SizedBox(height: 10,));
        });
      }

      setState(() {
        _loadingChats = false;
        renderState = !renderState;
      });


    }).onError((handleError) {

      setState(() {
        _loadingChats = false;
      });

      print("Error loading chats: ${handleError.toString()}");
    });
  }

  @override
  void initState() {
    loadChats();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: !_loadingChats? (_chats.length > 0? (renderState? SingleChildScrollView(
              child: Column(
                children: _chats,
              ),
            ) : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: _chats,
                ),
              ),
            )) : Column(
              children: [

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 150,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/blank_inbox_email.png", width: 150,
                    height: 150,),
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  child: Text(loc(context,  "you_dont_have_chats_yet"),
                  style: TextStyle(fontWeight: FontWeight.w600,
                  color: AppColors.mediumGray),
                  textAlign: TextAlign.center,),
                )


              ],
            )) : Column(
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
            )
          ),


          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
                ),
                child: Material(
                  color: Colors.white.withOpacity(0.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewChat()));

                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.chat, color: Colors.white,),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
