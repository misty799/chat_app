

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatEvent.dart';
import 'package:flutter_chat_app/bloc/userEvent.dart';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ChatBloc extends Bloc {
  String id;
 List<Chat> _allChats;
  List<Chat> get allChats => _allChats;
  StreamController<ChatEvent> _chatEventController =
      StreamController<ChatEvent>.broadcast();

  StreamSink<ChatEvent> get chatEventSink => _chatEventController.sink;

  Stream<ChatEvent> get _chatEventStream => _chatEventController.stream;

  StreamController<List<Chat>> _chatDataController =
      StreamController<List<Chat>>.broadcast();

  StreamSink<List<Chat>> get chatDataSink => _chatDataController.sink;

  Stream<List<Chat>> get chatDataStream => _chatDataController.stream;
 
  
  ChatBloc() {
    _chatEventStream.listen(mapEventToState);
  }
    Future<void> mapEventToState(ChatEvent event) async {
  if (event is AddChat) {

      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userId).collection(event.usersName).doc().set(event.chat.toJson());


    } 
     else if (event is FetchChats) {
      FirebaseFirestore.instance
          .collection("chatRoom").doc(event.userID).collection(event.usersName)
          .snapshots()
          .listen((snapshot) {
        _allChats = List<Chat>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChats.add(Chat.fromMap(snapshot.docs[i].data()));
        }
       // print("All users:${_allUsers.length}");
        chatDataSink.add(_allChats);
      });
     }
    }


    

  @override
  void dispose() {
    _chatEventController.close();
    _chatDataController.close();
  }
}

