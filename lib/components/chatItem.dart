import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {

  ChatData? data;
  Function(ChatData)? onPressed;
  int? pendingMessages;
  ChatItem({this.data, this.onPressed, this.pendingMessages});

  @override
  _ChatItemState createState() => _ChatItemState(data: data, onPressed: onPressed, pendingMessages: pendingMessages);
}

class _ChatItemState extends State<ChatItem> {

  ChatData? data;
  Function(ChatData)? onPressed;
  int? pendingMessages;
  _ChatItemState({this.data, this.onPressed, this.pendingMessages});

  String? otherID;
  String? otherName;

  @override
  void initState() {

    for(Map<String, dynamic> map in (data?.involvedData as List<Map<String, dynamic>>) ) {

      if(map["id"] != userID) {
        otherID = map["id"];
        otherName = map["name"];

      }


    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 6, offset: Offset(0, 4))]
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {

            onPressed?.call(data as ChatData);

          },
          child: Row(
            children: [

              SizedBox(width: 10,),

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: AppColors.form,
                    shape: BoxShape.circle
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(otherName != null? (otherName as String) : "-", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                            ),

                            data?.lastMessage != null? Text(AppUtilities.formatDateToTime(data?.lastMessage?.created as DateTime),
                            style: TextStyle(color:  pendingMessages != null && (pendingMessages as int) > 0? AppColors.primary : AppColors.mediumGray),) : Container()
                          ],
                        )
                      ),

                      SizedBox(height: 5,),

                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Text(data?.lastMessage?.message as String,
                                  style: TextStyle(color: AppColors.mediumGray),
                                  overflow: TextOverflow.ellipsis,),
                              )
                            ),

                            pendingMessages != null && (pendingMessages as int) > 0?Container(
                              width: 40,
                              height: 40,
                              child: Column(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("${pendingMessages}",
                                      style: TextStyle(color: Colors.white,
                                      fontSize: 12, fontWeight: FontWeight.w600),),
                                    ),
                                  )
                                ],
                              ),
                            ) : Container()
                          ],
                        )
                      )


                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),


            ],
          ),
        ),
      )
    );
  }
}
