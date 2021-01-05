import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';
import 'package:flutter_chat_app/Screens/chatRoom.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatEvent.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ChatPage extends StatefulWidget {
  final String user;
  ChatPage({this.user});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc _chatBloc;
  @override
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(
        FetchChatUsers(userID: auth.FirebaseAuth.instance.currentUser.uid));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,

        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: StreamBuilder<List<User>>(
                stream: _chatBloc.userDataStream,
                initialData: _chatBloc.allChatUsers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error"),
                      );
                    } else {
                      return Scrollbar(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  child: ListTile(
                                      title: Text(
                                        snapshot.data[i].name == null
                                            ? ""
                                            : "${snapshot.data[i].name[0].toUpperCase()}${snapshot.data[i].name.substring(1)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[i].photopath == null
                                                  ? ""
                                                  : snapshot
                                                      .data[i].photopath))),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                  user: widget.user,
                                                  receiverName:
                                                      snapshot.data[i].name,
                                                )));
                                  },
                                );
                              }));
                    }
                  } else {
                    return Container(
                      child: Text(""),
                    );
                  }
                })));
  }
}
