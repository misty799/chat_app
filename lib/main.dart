
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_chat_app/Screens/Authenticate/login_Screen.dart';
import 'package:flutter_chat_app/Screens/RouteScreen.dart';
import 'package:flutter_chat_app/bloc/ChatBloc/chatbloc.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/authbloc.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/authevent.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/authstate.dart';
import 'package:flutter_chat_app/bloc/AuthenticationBloc/simple_bloc_observer.dart';
import 'package:flutter_chat_app/bloc/userBloc.dart';
import 'package:flutter_chat_app/bloc/userRepository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

  bloc.Bloc.observer = SimpleBlocObserver();
  
  final UserRepository userRepository = UserRepository();
  runApp(
    bloc.BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      bloc: UserBloc(), child: 
      BlocProvider<ChatBloc>(bloc:ChatBloc(),
      child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff6a515e),
        cursorColor: Color(0xff6a515e),
      ),
      home: 
      bloc.BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository,);
          }

          if (state is AuthenticationSuccess) {
         return RouteScreen(user: state.firebaseUser,);
            
          }

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(child: Text("Loading")),
            ),
          );
        },
      ),
    )));
  }
}

