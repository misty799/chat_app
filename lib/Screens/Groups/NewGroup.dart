import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/Models/chat.dart';
import 'package:flutter_chat_app/Screens/home.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatEvent.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class NewGroup extends StatefulWidget {
  final GroupPeople groupPeople;
  final User user;
  NewGroup({this.user, this.groupPeople});
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  ChatBloc _chatBloc;

  @override
  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    super.didChangeDependencies();
  }

  TextEditingController textEditingController = TextEditingController();
  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("New group")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(height: 20.0),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: _image == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 30.0,
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          labelText: 'Please type group subject here'),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Text(
                      "Participants",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.groupPeople.groupUsers.length,
                          itemBuilder: (context, i) {
                            return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Text(widget.groupPeople.groupUsers[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle()));
                          })),
                  SizedBox(height: 20.0),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: FlatButton(
                          onPressed: () async {
                            _chatBloc.chatEventSink.add(AddGroups(
                              groupPeople: widget.groupPeople,
                            ));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          user: widget.user,
                                        )));
                          },
                          child: Text(
                            'create',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )))
                ]))));
  }
}
