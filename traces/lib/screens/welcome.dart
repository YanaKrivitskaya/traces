import 'package:flutter/material.dart';
import 'package:traces/auth/bloc.dart';
//import 'package:traces/auth/firebaseUserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/auth/repository/apiUserRepository.dart';

class WelcomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>{
  final userRepository = new ApiUserRepository();

  //final FirebaseUserRepository _userRepository = FirebaseUserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc();
    _authenticationBloc.add(AppStarted());
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState state){
        return _buildWaitingScreen();
      }
    );
  }


  @override
  void dispose(){
    _authenticationBloc.close();
    super.dispose();
  }
}