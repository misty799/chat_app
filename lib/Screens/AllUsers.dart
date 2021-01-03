import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Screens/chatRoom.dart';
import 'package:flutter_chat_app/bloc/userBloc.dart';
import 'package:flutter_chat_app/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:search_page/search_page.dart';

class AllUsers extends StatefulWidget {
  final String user;
  AllUsers({this.user});
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  UserBloc _userBloc;
  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.userEventSink.add(FetchAllUser());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("All Contacts",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent),
          Positioned(
              top: 70.0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width)),
          Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                onTap: () => displaySearch(),
                decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.filter_list),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0)),
              )),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 100.0,
              ),
              child: StreamBuilder<List<User>>(
                  stream: _userBloc.userDataStream,
                  initialData: _userBloc.allUsers,
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
                                  return ListTile(
                                      title: Text(
                                        snapshot.data[i].name == null
                                            ? ""
                                            : "${snapshot.data[i].name[0].toUpperCase()}${snapshot.data[i].name.substring(1)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {

                                             Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>ChatRoom(user: widget.user,
                                            receiverName: snapshot.data[i].name,
                                              )));






                                          }),
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[i].photopath == null
                                                  ? ""
                                                  : snapshot
                                                      .data[i].photopath)));
                                }));
                      }
                    } else {
                      return Container(
                        child: Text(""),
                      );
                    }
                  }))
        ]));
  }

  void displaySearch() async {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    showSearch(
        context: context,
        delegate: SearchPage<User>(
            items: userBloc.allUsers,
            searchLabel: 'Search People',
            suggestion: Center(
              child: Text('Filter People by name'),
            ),
            failure: Center(
              child: Text('No ParentingTips found :('),
            ),
            filter: (person) => [
                  person.name,
                ],
            builder: (person) => ListTile(
                title: Text(
                  person.name == null
                      ? ""
                      : "${person.name[0].toUpperCase()}${person.name.substring(1)}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                trailing: IconButton(icon: Icon(Icons.send), onPressed: () {}),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        person.photopath == null ? "" : person.photopath)))));
  }
}
