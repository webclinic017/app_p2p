import 'package:app_p2p/components/messageItem.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  ChatData? data;
  ConversationScreen({this.data});


  @override
  _ConversationScreenState createState() => _ConversationScreenState(data: data);
}

class _ConversationScreenState extends State<ConversationScreen> {

  ChatData? data;
  _ConversationScreenState({this.data});

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
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),

        centerTitle: true,
        title: Text(otherName != null? (otherName as String) : "-",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
        
        actions: [
          
          IconButton(onPressed: () {

          }, icon: Icon(Icons.more_vert, color: Colors.white,))

        ],


      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [

            SizedBox(height: 20,),

            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: _messages,
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
                  SizedBox(width: 20,),
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
                      color: Colors.white,
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
                          child: Icon(Icons.send, color: AppColors.primary,),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20,),


                ],
              ),
            )

          ],
        ),
      ),
    );
  }


  void sendMessage () {

    setState(() {
      _messages.add(MessageItem(data: MessageData(id: "message", chatID: "chat1",
      message: _message,
      senderID: userID, seen: false, created: DateTime.now()),));

      _messages.add(SizedBox(height: 10,));
    });

    print("Message created!");
  }
}
