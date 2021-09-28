import 'dart:io';
import 'dart:math';

import 'package:app_p2p/components/loadMore.dart';
import 'package:app_p2p/components/loader.dart';
import 'package:app_p2p/components/messageItem.dart';
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConversationScreen extends StatefulWidget {

  ChatData? data;
  Function()? onBack;
  ConversationScreen({this.data, this.onBack});


  @override
  _ConversationScreenState createState() => _ConversationScreenState(data: data,
  onBack: onBack);
}

class _ConversationScreenState extends State<ConversationScreen> {

  ChatData? data;
  Function()? onBack;
  _ConversationScreenState({this.data, this.onBack});


  bool _isLoading = false;
  String _loadMessage = "";

  String? otherID;
  String? otherName;
  String? otherImageUrl;

  String? _message;

  List<Widget> _messages = [];

  TextEditingController _messageController = TextEditingController();

  void loadOtherData() {

    for(Map<String, dynamic> userMap in (data?.involvedInfo as List<Map<String, dynamic>>)) {

      if(userID != userMap["id"]) {
        setState(() {
          otherID = userMap["id"];
          otherName = userMap["name"];
          if(userMap.containsKey("url")) {
            otherImageUrl = userMap["url"];
          }
        });
        break;
       
      }

    }

  }

  @override
  void initState() {
    super.initState();
    loadOtherData();
    loadMessages();

    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }


  int _loadLimit = 20;
  List<String> _messagesID = [];
  bool _renderState = false;
  DocumentSnapshot? _lastDoc;


  ScrollController _scrollController = ScrollController();

  void loadMessages() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.chats).doc(data?.id)
    .collection(AppDatabase.messages).orderBy(AppDatabase.created, descending: true)
        .limit(_loadLimit).snapshots().listen((event) {


      List<Widget> messagesBatch = [];

      for(var doc in event.docs) {


        if(!_messagesID.contains(doc.id)) {
          MessageData messageData = MessageData.fromDoc(doc);

          messagesBatch.add(MessageItem(data: messageData,));
          messagesBatch.add(SizedBox(height: 10,));
          _messagesID.add(doc.id);
        }

        _lastDoc = doc;


      }

      setState(() {
        _messages.addAll(messagesBatch.reversed);
        _renderState = !_renderState;

      });



      if(messagesBatch.length >= _loadLimit) {
        setState(() {
          _messages.insert(0, LoadMore(onLoad: () {

            loadMoreMessages();

          },));
        });
      }

      Future.delayed(Duration(milliseconds: 50), () {

        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.ease);

      });






    }).onError((onError) {

      print("Error loading messages: ${onError.toString()}");
    });
  }


  void loadMoreMessages() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.chats).doc(data?.id)
        .collection(AppDatabase.messages).orderBy(AppDatabase.created, descending: true)
        .startAfterDocument( _lastDoc as DocumentSnapshot).limit(_loadLimit).get().then((query) {

      List<Widget> messagesBatch = [];

      setState(() {
        _messages.removeAt(0);
      });

      for(var doc in query.docs) {

        MessageData messageData = MessageData.fromDoc(doc);

        messagesBatch.add(SizedBox(height: 10,));
        messagesBatch.add(MessageItem(data: messageData,));


        _lastDoc = doc;


      }



      setState(() {
        _messages.insertAll(0, messagesBatch.reversed);
        _renderState = !_renderState;

      });

      if(messagesBatch.length >= _loadLimit) {
        setState(() {
          _messages.insert(0, LoadMore(onLoad: () {

            loadMoreMessages();

          },));
        });
      }





    }).catchError((onError) {

      print("Error loading more messages: ${onError.toString()}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(onPressed: () {

            onBack?.call();
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),

          centerTitle: true,
          title: Text(otherName != null? (otherName as String) : "-",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),

          actions: [

            IconButton(onPressed: () {

            }, icon: Icon(Icons.call)),

            IconButton(onPressed: () {

            }, icon: Icon(Icons.more_vert, color: Colors.white,))

          ],


        ),

        body: Stack(
          children: [

            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [



                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: !_renderState? SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: _messages,
                        ),
                      ) : Container(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: _messages,
                          ),
                        ),
                      ),
                    ),
                  ),






                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1, blurRadius: 6, offset: Offset(0, -4))]
                    ),
                    child: Row(
                      children: [

                        SizedBox(width: 10,),


                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 3))]
                          ),
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(45),
                              onTap: () {

                                pickFile();
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.attach_file,),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                color: AppColors.form,
                                borderRadius: BorderRadius.circular(45),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 3))]
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: loc(context, "enter_the_message"),
                                    hintStyle: TextStyle(color: AppColors.mediumGray)
                                ),
                                controller: _messageController,
                                onChanged: (value) {
                                  setState(() {
                                    _message = value;
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    _message = value;
                                  });
                                  sendMessage();
                                  _messageController.clear();
                                },
                              ),
                            ),

                          ),
                        ),

                        SizedBox(width: 10,),

                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6)
                              )]
                          ),
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(45),
                              onTap: _message != null?() {

                                sendMessage();
                                _messageController.clear();
                              } : null,
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.send, color: Colors.white,),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),


                      ],
                    ),
                  )

                ],
              ),
            ),


            _isLoading? Loader(loadMessage: _loadMessage,) : Container()
          ],
        ),
      ), onWillPop: () async{

        onBack?.call();
        Navigator.pop(context);

        return false;
    },
    );
  }


  FilePickerResult? pickerResult;
  void pickFile () async{

    pickerResult = await FilePicker.platform.pickFiles();


    if (pickerResult != null) {
      File file = File(pickerResult?.files.single.path as String);

      uploadFile(file);
    } else {
      // User canceled the picker
    }
  }

  void uploadFile(File file) {
    var storage = FirebaseStorage.instance.ref();

    setState(() {
      _isLoading = true;
      _loadMessage = "${loc(context, "uploading_file")}...";
    });


    int imageNumber = Random().nextInt(99999);
    String imagePath = "${AppDatabase.chats}/${data?.id}/$imageNumber.png";

    storage.child(imagePath).putFile(file).then((result) async{

      Fluttertoast.showToast(
          msg: loc(context, "file_uploaded"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

      String url = await result.ref.getDownloadURL();

      sendMessageWithFile(imagePath, url, (pickerResult?.files.single.extension as String),
          (pickerResult?.files.single.name as String));

      setState(() {
        _isLoading = false;
      });

    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: loc(context, "an_error_has_occurred"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white.withOpacity(0.8),
          fontSize: 16.0
      );

      print("Error uploading message file: ${onError.toString()}");
    });


  }



  List<MessageItem> _messagesItems = [];

  void sendMessage () {
    var firestore = FirebaseFirestore.instance;

    String id = firestore.collection(AppDatabase.chats).doc(data?.id)
    .collection(AppDatabase.messages).doc().id;

    setState(() {



      _messages.add(SizedBox(height: 10,));
      MessageItem item = MessageItem(data: MessageData(chatID: data?.id,
          message: _message,
          senderID: userID, seen: false, created: DateTime.now()), id: id,);

      _messages.add(item);
      _messagesItems.add(item);

      if(_messagesItems.length > 1) {
        _messagesItems[_messagesItems.length-2].id = null;
      }


      _messagesID.add(id);
    });


    Future.delayed(Duration(milliseconds: 50), () {

      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);

    });



    print("Message created!");
  }


  void sendMessageWithFile(String filePath, String fileUrl,
      String fileExtension, String fileName) {
    var firestore = FirebaseFirestore.instance;

    String id = firestore.collection(AppDatabase.chats).doc(data?.id)
        .collection(AppDatabase.messages).doc().id;

    setState(() {



      _messages.add(SizedBox(height: 10,));
      MessageItem item = MessageItem(data: MessageData(chatID: data?.id,
          message: _message,
          senderID: userID, seen: false, created: DateTime.now(),
      filePath: filePath,
      fileUrl: fileUrl,
      fileExtension: fileExtension,
      fileName: fileName), id: id,);

      _messages.add(item);
      _messagesItems.add(item);

      if(_messagesItems.length > 1) {
        _messagesItems[_messagesItems.length-2].id = null;
      }


      _messagesID.add(id);
    });


    Future.delayed(Duration(milliseconds: 50), () {

      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);

    });
  }
}
