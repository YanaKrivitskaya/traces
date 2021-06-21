import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constants.dart';

class SettingsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 40.0))
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
            backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.gloomyPurple),
            foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.lynxWhite)
          ),
          child: Text('Go back!'),
        ),
      ),
    );
  }
}