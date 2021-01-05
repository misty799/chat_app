
import 'dart:io';

import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';


abstract class ChatEvent{

}
class AddChat extends ChatEvent{
  final Chat chat;
  final String userId;
  final String usersName;
  AddChat({this.chat,this.userId,this.usersName});

}
class AddChatUsers extends ChatEvent{
  final User user;
  final String userId;
  final String uid;
  AddChatUsers({this.user,this.userId,this.uid});
}

class FetchChats extends ChatEvent {
  final String userID;
  final String usersName;

  FetchChats({ this.userID,this.usersName});
}
class FetchChatUsers extends ChatEvent {
  final String userID;

  FetchChatUsers({ this.userID});
}

class AddGroups extends ChatEvent{
  final GroupPeople groupPeople;
  AddGroups({this.groupPeople});
}
class FetchGroups extends ChatEvent{

}
class AddGroupChats extends ChatEvent{
  final String uid;
  final Chat chat;
  AddGroupChats({this.uid,this.chat});
}
class FetchGroupChats extends ChatEvent{
  final String docId;
  FetchGroupChats({this.docId});

}