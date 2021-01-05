import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';
import 'package:flutter_chat_app/Screens/Groups/groupChatRoom.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatEvent.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class GroupPage extends StatefulWidget {
  final User user;
  GroupPage({this.user});
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  ChatBloc _chatBloc;
  @override
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(FetchGroups());
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
            child: StreamBuilder<List<GroupPeople>>(
                stream: _chatBloc.groupDataStream,
                initialData: _chatBloc.allGroups,
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
                                if (snapshot.data[i].groupUsers
                                    .contains(widget.user.name)) {
                                  return GestureDetector(
                                      child: ListTile(
                                          title: Text(
                                            snapshot.data[i].groupUsers[0],
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                          ),
                                          leading: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(""))),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupChatRoom(
                                                      docId: snapshot
                                                          .data[i].docId,
                                                    )));
                                      });
                                } else {
                                  return Container(
                                    child: Text(""),
                                  );
                                }
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
