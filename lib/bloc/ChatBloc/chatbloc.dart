import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatEvent.dart';
import 'package:flutter_chat_app/bloc/userEvent.dart';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ChatBloc extends Bloc {
  String id;
  List<Chat> _allChats;
  List<Chat> get allChats => _allChats;
  List<GroupPeople> _allGroups;
  List<GroupPeople> get allGroups => _allGroups;
  List<User> _allChatUsers;
  List<User> get allChatUsers => _allChatUsers;
  StreamController<List<User>> _userDataController =
      StreamController<List<User>>.broadcast();

  StreamSink<List<User>> get userDataSink => _userDataController.sink;

  Stream<List<User>> get userDataStream => _userDataController.stream;
  StreamController<List<GroupPeople>> _groupDataController =
      StreamController<List<GroupPeople>>.broadcast();

  StreamSink<List<GroupPeople>> get groupDataSink => _groupDataController.sink;

  Stream<List<GroupPeople>> get groupDataStream => _groupDataController.stream;

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
          .doc(event.userId)
          .collection(event.usersName)
          .doc()
          .set(event.chat.toJson());
    } else if (event is AddChatUsers) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userId)
          .collection("ChatUsers")
          .doc(event.uid)
          .set(event.user.toJson(event.userId));
          
    } else if (event is AddGroups) {

    DocumentReference docRef=  FirebaseFirestore.instance
          .collection("Groups").doc();
         docRef .set({"docId":docRef.id});

         FirebaseFirestore.instance.collection("Groups").doc(docRef.id).update( { "users"  :       
           event.groupPeople.groupUsers});
             FirebaseFirestore.instance.collection("Groups").doc(docRef.id).update( { "usersId"  :       
           event.groupPeople.usersID});
    } else if (event is AddGroupChats) {
      FirebaseFirestore.instance
          .collection("Groups")
          .doc(event.uid)
          .collection("groupchats")
          .doc()
          .set(event.chat.toJson());
    } else if (event is FetchChats) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userID)
          .collection(event.usersName)
          .snapshots()
          .listen((snapshot) {
        _allChats = List<Chat>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChats.add(Chat.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        chatDataSink.add(_allChats);
      });
    } else if (event is FetchGroups) {
      FirebaseFirestore.instance
          .collection("Groups")
          .snapshots()
          .listen((snapshot) {
        _allGroups = List<GroupPeople>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allGroups.add(GroupPeople.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        groupDataSink.add(_allGroups);
      });
    } else if (event is FetchGroupChats) {
      FirebaseFirestore.instance
          .collection("Groups")
          .doc(event.docId)
          .collection("groupchats")
          .snapshots()
          .listen((snapshot) {
        _allChats = List<Chat>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChats.add(Chat.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        chatDataSink.add(_allChats);
      });
    } else if (event is FetchChatUsers) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(event.userID)
          .collection("ChatUsers")
          .snapshots()
          .listen((snapshot) {
        _allChatUsers = List<User>();
        for (int i = 0; i < snapshot.docs.length; i++) {
          _allChatUsers.add(User.fromMap(snapshot.docs[i].data()));
        }
        // print("All users:${_allUsers.length}");
        userDataSink.add(_allChatUsers);
      });
    }
  }

  @override
  void dispose() {
    _chatEventController.close();
    _chatDataController.close();
    _groupDataController.close();
    _userDataController.close();
  }
}
