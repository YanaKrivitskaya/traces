import 'package:flutter/material.dart';
import 'package:traces/auth/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>{

  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
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