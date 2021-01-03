
import 'dart:io';

import 'package:flutter_chat_app/Models/chat.dart';


abstract class ChatEvent{

}
class AddChat extends ChatEvent{
  final Chat chat;
  final String userId;
  final String usersName;
  AddChat({this.chat,this.userId,this.usersName});

}

class FetchChats extends ChatEvent {
  final String userID;
  final String usersName;

  FetchChats({ this.userID,this.usersName});
}
