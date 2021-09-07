

import 'package:app_p2p/database/messageData.dart';

class ChatData {

  String? id;
  List<String>? involved;
  List<Map<String, dynamic>>? involvedData;
  MessageData? lastMessage;
  DateTime? created;
  DateTime? updated;

  ChatData({this.id, this.involved, this.involvedData, this.lastMessage, this.created, this.updated});

}