import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/constants.dart';
import 'package:traces/services/auth.dart';
import '../colorsPalette.dart';

class ProfilePage extends StatefulWidget{

  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return new _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))
        ),
        centerTitle: true
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
            RaisedButton(
              onPressed: () {
                _logout();
              },
              child: Text('Logout'),
            ),
          ],
        )
      ),
    );
  }

  _logout() async {
    await widget.auth.logout();
    Navigator.of(context).pushNamedAndRemoveUntil(Navigator.defaultRouteName, (Route<dynamic> route) => false);
  }
}