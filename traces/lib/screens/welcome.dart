import 'package:flutter/material.dart';
import 'package:traces/screens/home.dart';
import 'package:traces/screens/loginSignup.dart';
import '../constants.dart';
import '../services/auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class WelcomePage extends StatefulWidget{
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>{
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    checkForToken();
  }

  checkForToken() async {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        if(user != null){
          _userId = user?.uid;
        }
        _authStatus = user?.uid != null ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context){
    switch(_authStatus){
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}