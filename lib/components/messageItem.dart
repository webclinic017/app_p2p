import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {

  MessageData? data;

  MessageItem({this.data});

  @override
  _MessageItemState createState() => _MessageItemState(
    data: data
  );
}

class _MessageItemState extends State<MessageItem> {

  MessageData? data;
  _MessageItemState({this.data});

  bool _sendingMessage = false;




  Widget get mineMessage => Row(
    children: [


      Expanded(
        child: Container(),
      ),



      _sendingMessage? Container(
        width: 35,
        height: 35,
        child: FittedBox(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
        ),
      ) : Container(),

      SizedBox(width: 10,),

      Text(AppUtilities.formatDateToTime(data?.created as DateTime),
      style: TextStyle(color: AppColors.mediumGray),),


      SizedBox(width: 10,),


      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 250),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(data?.message as String, style: TextStyle(color: Colors.white),),
            ),
          )
      ),

      SizedBox(width: 20,),
    ],
  );




  Widget get otherMessage => Row(
    children: [
      SizedBox(width: 20,),

      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 250),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(data?.message as String),
            ),
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


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: isMine? mineMessage : otherMessage
    );
  }
}
