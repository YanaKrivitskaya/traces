import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traces/auth/firebaseUserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/loginSignup/bloc/bloc.dart';

import 'loginSignup_form.dart';

class LoginSignupPage extends StatelessWidget{
  final FirebaseUserRepository _userRepository;

  LoginSignupPage({@required FirebaseUserRepository userRepository})
    :assert (userRepository != null),
    _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginSignupBloc>(
        create: (context) => LoginSignupBloc(userRepository: _userRepository),
        child: LoginSignupForm(),
      ),
    );
  }
}