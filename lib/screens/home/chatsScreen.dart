import 'package:app_p2p/components/chatItem.dart';
import 'package:app_p2p/database/chatData.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/screens/home/conversationScreen.dart';
import 'package:app_p2p/screens/home/newChat.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {


  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {




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
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 20,),

                  ChatItem(data: ChatData(id: "chat1", involved: ["user1", "user2"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user2",
                          "name" : "Alejandro Hernandez",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat1",
                          message: "Hola tio",
                          senderID: "user1", seen: false, created: DateTime.now())),
                  onPressed: (data) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(
                      data: data,
                    )));
                  },),

                  SizedBox(height: 10,),

                  ChatItem(data: ChatData(id: "chat2", involved: ["user1", "user4"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user2",
                          "name" : "Carlos Perez",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat2",
                          message: "¿Cuando podemos ir a tomar algo?",
                          senderID: "user1", seen: false, created: DateTime.now().subtract(Duration(minutes: 20)))),),



                  SizedBox(height: 10,),

                  ChatItem(data: ChatData(id: "chat2", involved: ["user1", "user4"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user2",
                          "name" : "Carlos Perez",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat2",
                          message: "¿Cuando podemos ir a tomar algo?",
                          senderID: "user1", seen: false, created: DateTime.now().subtract(Duration(minutes: 36)))),),


                  SizedBox(height: 10,),

                  ChatItem(data: ChatData(id: "chat6", involved: ["user1", "user4"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user4",
                          "name" : "Olivarez Figueroa",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat6",
                          message: "Que maravilla lo que acabas de hacer",
                          senderID: "user1", seen: false, created: DateTime.now().subtract(Duration(minutes: 45)))),
                    pendingMessages: 2,),


                  SizedBox(height: 10,),

                  ChatItem(data: ChatData(id: "chat3", involved: ["user1", "user3"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user3",
                          "name" : "Adriana Rodriguez",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat3",
                          message: "Tenemos algo pendiente",
                          senderID: "user1", seen: false, created: DateTime.now().subtract(Duration(minutes: 47)))),
                    pendingMessages: 4,),

                  SizedBox(height: 10,),

                  ChatItem(data: ChatData(id: "chat4", involved: ["user1", "user5"],
                      involvedInfo: [
                        {
                          "id" : "user1",
                          "name" : "Esteban Hernandez",
                        },
                        {
                          "id" : "user5",
                          "name" : "Fernando M",
                        }
                      ],
                      lastMessage: MessageData(id: "message1", chatID: "chat4",
                          message: "Esto esta genial colega",
                          senderID: "user1", seen: false, created: DateTime.now().subtract(Duration(minutes: 48)))),
                    pendingMessages: 10,),



                ],
              ),
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
