import 'package:app_p2p/database/chatData.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
