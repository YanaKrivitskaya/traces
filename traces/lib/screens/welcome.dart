import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/constants.dart';
import '../colorsPalette.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>{

  @override
  void initState() {
    super.initState();
    checkForToken();
  }

  checkForToken(){
    FirebaseAuth.instance.currentUser().then((user){
      if(user!=null){
        Navigator.pushReplacementNamed(context, homeRoute);
      }else{
        Navigator.pushReplacementNamed(context, loginRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        /*child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),*/

      ),
    );
  }
}