import 'package:app_p2p/components/button.dart';
import 'package:app_p2p/components/chatItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/localDatabase/localDatabase.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/home/bluetooth/bluetoothScanner.dart';
import 'package:app_p2p/screens/home/bluetooth/chatPage.dart';
import 'package:app_p2p/screens/home/conversationScreen.dart';
import 'package:app_p2p/screens/home/newChat.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatsScreen extends StatefulWidget {

  Function(int)? onUnreadMessages;

  ChatsScreen({this.onUnreadMessages});


  @override
  _ChatsScreenState createState() => _ChatsScreenState(onUnreadMessages: onUnreadMessages);
}

class _ChatsScreenState extends State<ChatsScreen> {

  Function(int)? onUnreadMessages;

  _ChatsScreenState({this.onUnreadMessages});

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";


  int _loadLimit = 20;
  List<Widget> _chats = [];

  bool _loadingChats = false;
  bool renderState = false;

  int _unreadMessages = 0;

  BluetoothDevice? selectedDevice;

  String CHANNEL = "com.soflop.app_p2p/bluetooth";
  MethodChannel? platform;

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

    initBluetooth();

   
    
    initBluetooth();

    super.initState();
  }


  void initBluetooth() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) == true) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address as String;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name as String;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    platform = MethodChannel(CHANNEL);
    
    try {
      var result = await platform?.invokeMethod("initAsBluetoothServer");
      if(result == true) {
        print("LISTENING!!");
      }

      
    }catch(e) {
      print("Error staring a server: ${e}");
    }

  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
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


  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

}
