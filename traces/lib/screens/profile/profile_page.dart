
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/profile/profile_view.dart';

class ProfilePage extends StatelessWidget{
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.white, fontSize: 25.0))),
        //backgroundColor: ColorsPalette.c64Ntsc,
        backgroundColor: ColorsPalette.meditSea,
        //backgroundColor: ColorsPalette.pureApple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ProfileView(),
    );
  }

}