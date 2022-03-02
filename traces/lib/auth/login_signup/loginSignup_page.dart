import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'loginSignup_form.dart';

class LoginSignupPage extends StatelessWidget{
  
  LoginSignupPage();    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginSignupBloc>(
        create: (context) => LoginSignupBloc(),
        child: LoginSignupForm(),
      ),
    );
  }
}