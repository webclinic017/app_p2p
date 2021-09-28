import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageItem extends StatefulWidget {

  MessageData? data;
  String? id;


  MessageItem({this.data, this.id});

  @override
  _MessageItemState createState() => _MessageItemState(
    data: data, id: id,
  );
}

class _MessageItemState extends State<MessageItem> {

  MessageData? data;
  String? id;


  _MessageItemState({this.data, this.id});




  bool get isImage {
    if(data?.fileUrl == null) {
      return false;
    }

    return ((data?.fileExtension as String).contains("jpg") || (data?.fileExtension as String).contains("png"));

  }




  Widget get mineMessage => Row(
    children: [


      Expanded(
        child: Container(),
      ),



      _creatingMessage? Container(
        width: 35,
        height: 35,
        child: FittedBox(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
        ),
      ) : (data?.seen == true? Row(
        children: [
          Icon(Icons.check, color: Colors.blue, size: 15,),

          Icon(Icons.check, color: Colors.blue, size: 15,)
        ],
      ) : Row(
        children: [
          Icon(Icons.check, color: AppColors.mediumGray, size: 15,),

          Icon(Icons.check, color: AppColors.mediumGray, size: 15,)
        ],
      )),

      SizedBox(width: 10,),

      Text(AppUtilities.formatDateToTime(data?.created as DateTime),
      style: TextStyle(color: AppColors.mediumGray),),


      SizedBox(width: 10,),


      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 200),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: data?.fileUrl == null? null : () {

                  launch(data?.fileUrl as String);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: data?.fileUrl == null? Text(data?.message as String,
                  style: TextStyle(color: Colors.white),) : (isImage? _messageImage :
                  Text(data?.fileName as String,

                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.w600),)),
                ),
              ),
            )
          )
      ),

      SizedBox(width: 20,),
    ],
  );




  Widget get otherMessage => Row(
    children: [
      SizedBox(width: 20,),

      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 200),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: data?.fileUrl == null? null : () {

                  launch(data?.fileUrl as String);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: data?.fileUrl == null? Text(data?.message as String) : (isImage? _messageImage :
                  Text(data?.fileName as String,

                    style: TextStyle(color: Colors.blue,
                    fontWeight: FontWeight.w600),)),
                ),
              ),
            )
          )
      ),


      SizedBox(width: 10,),

      Text(AppUtilities.formatDateToTime(data?.created as DateTime),
        style: TextStyle(color: AppColors.mediumGray),),





      Expanded(
        child: Container(),
      ),

    ],
  );



  bool get isMine => data?.senderID == userID;


  Image? _messageImage;

  @override
  void initState() {

    if(id != null) {
      createMessage();
    }

    if(!isMine && data?.seen == false) {
      setSeen();
    }

    if(isImage) {
      loadMessageImage();
    }


    super.initState();
  }

  void loadMessageImage () {

    setState(() {
      _messageImage = Image.network(data?.fileUrl as String, width: 200,
      fit: BoxFit.fitWidth,);
    });
  }


  void setSeen() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.chats).doc(data?.chatID)
    .collection(AppDatabase.messages).doc(data?.id).update({
      AppDatabase.seen: true
    }).then((result) {

      setState(() {
        data?.seen = true;
      });

    }).catchError((onError) {

      print("Error setting seen: ${onError.toString()}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: isMine? mineMessage : otherMessage
    );
  }

  bool _creatingMessage = false;

  void createMessage() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _creatingMessage = true;
    });

    var batch = firestore.batch();

    var messageDoc = firestore.collection(AppDatabase.chats).doc(data?.chatID)
        .collection(AppDatabase.messages).doc(id);

    batch.set(messageDoc, data?.toMap() as Map<String, dynamic>);


    var chatDoc = firestore.collection(AppDatabase.chats).doc(data?.chatID);

    batch.update(chatDoc, {
      AppDatabase.lastMessage: {
        AppDatabase.chatID: data?.chatID,
        AppDatabase.message: data?.filePath == null? data?.message : data?.fileName,
        AppDatabase.senderID: data?.senderID,
        AppDatabase.seen: data?.seen,
        AppDatabase.created: data?.created
      }
    });







    batch.commit().then((result) async{



      if(!mounted) {
        return;
      }



      var chatDoc2 = await firestore.collection(AppDatabase.chats).doc(data?.chatID).get();

      ChatData chatData = ChatData.fromDoc(chatDoc2);

      String receiver = "";
      for(String ids in chatData.involved as List<String>) {

        if(ids != userID){
          receiver = ids;
          break;
        }

      }

      String title = "${currentUserData?.firstName} ${currentUserData?.lastName} te envió un mensaje";
      String content = data?.message as String;

      firestore.collection(AppDatabase.users)
          .doc(receiver).collection(AppDatabase.notifications).doc().set({
        AppDatabase.title: title,
        AppDatabase.content: content,
        AppDatabase.seen: false,
        AppDatabase.created: DateTime.now()
      });


      try {
        var response = await Dio().post("https://cuidabu.herokuapp.com/sendNotification",data: {
          "receiver" : receiver,
          "title" : title,
          "content" : content
        });
        print("Notification sent!");


      }catch(e) {

        print("Error sending message: ${e.toString()}");

      }


      setState(() {
        _creatingMessage = false;
      });
    }).catchError((onError) {

      if(!mounted) {
        return;
      }

      setState(() {
        _creatingMessage = false;
      });

      print("Error creating message: ${onError.toString()}");
    });
  }
}
