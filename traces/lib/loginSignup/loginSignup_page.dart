import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/loginSignup/bloc/bloc.dart';

import 'loginSignup_form.dart';

class LoginSignupPage extends StatelessWidget{
  final UserRepository _userRepository;

  LoginSignupPage({@required UserRepository userRepository})
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