import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_chat_app/Models/User.dart';
import 'package:flutter_chat_app/bloc/authbloc.dart';
import 'package:flutter_chat_app/bloc/authevent.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_chat_app/bloc/registerbloc.dart';
import 'package:flutter_chat_app/bloc/registerevent.dart';
import 'package:flutter_chat_app/bloc/registerstate.dart';
import 'package:flutter_chat_app/bloc/userBloc.dart';
import 'package:flutter_chat_app/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  
   UserBloc _userBloc;
  String downloadUrl;

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }
 


  final TextEditingController _emailController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = bloc.BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return bloc.BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Register Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Registering...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess) {
          bloc.BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
          Navigator.pop(context);
        }
      },
      child: bloc.BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: <Widget>[
                   TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: "Name",
                    ),
                    keyboardType: TextInputType.name,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (value)=>value.isEmpty?"Name is required":null
                  
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Password",
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(

                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        _onFormSubmitted();
                       
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                   
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }
  

  void _onFormSubmitted() {
_registerBloc.add(RegisterSubmitted(
        email: _emailController.text, password: _passwordController.text));
   

  }
}
