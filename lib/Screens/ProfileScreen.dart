import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_chat_app/Screens/home.dart';
import 'package:flutter_chat_app/bloc/userBloc.dart';
import 'package:flutter_chat_app/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final auth.User user;
  ProfileScreen({this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _userBloc;
  User user;

  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _childName = "";
  String _email = "";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Profile"),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: _image == null
                              ? Icon(Icons.add_a_photo)
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
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  name!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _childName = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email-Id'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  Email!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _email = value;
                        },
                      ),
                    ),
                    RaisedButton(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                      /*  if (_image == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Alert!!'),
                              content: Text('Pick Image .'),
                              actions: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(true),
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
*/
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        print(_image);
                        print(_childName);

                        User newUser = User(name: _childName, email: _email,userId: widget.user.uid
                            // sketches: {}
                            );
                        _userBloc.userEventSink
                            .add(AddUser(user: newUser, file: _image));
                        //Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ));
                      },
                    ),
                  ],
                ))));
  }
}
