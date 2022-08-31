import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'loginSignup_form.dart';

class LoginSignupPage extends StatelessWidget{
  
  LoginSignupPage();    

  @override
  Widget build(BuildContext context) {
    
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<LoginSignupBloc>(
        create: (context) => LoginSignupBloc(),
        child: LoginSignupForm(_scaffoldKey),
      ),
    );
  }
}