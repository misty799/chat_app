import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Screens/AllUsers.dart';
import 'package:flutter_chat_app/Screens/ChatPage.dart';
import 'package:flutter_chat_app/Screens/Groups/GroupPage.dart';
import 'package:flutter_chat_app/Screens/profilePage.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/authbloc.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/authevent.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            title: Center(
              child: Text(
                "Chatter",
                style: TextStyle(color: Colors.white),
              ),
            ),

//

            bottom: TabBar(
                /*     unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[300]
        ),*/
                tabs: [
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chats",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Groups",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ]),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLoggedOut());
                },
              )
            ],
          ),
          body: TabBarView(children: [
            ChatPage(
              user: widget.user.name,
            ),
            GroupPage(
              user: widget.user,
            ),
            ProfilePage(
              user: widget.user,
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllUsers(
                            user: widget.user,
                          )));
            },
            child: Icon(Icons.search),
          ),
        ));
  }
}
