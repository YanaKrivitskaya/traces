import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import 'bloc/settings_bloc.dart';
import 'repository/firebase_appSettings_repository.dart';
import 'settings_view.dart';

class SettingsPage extends StatelessWidget{
  SettingsPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => 
        SettingsBloc(/*settingsRepository: FirebaseAppSettingsRepository()*/)
          ..add(GetAppSettings()),
      child: WillPopScope(
        onWillPop: (()=> Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false) as Future<bool>) as Future<bool> Function()?,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Settings', style: GoogleFonts.quicksand(textStyle: TextStyle(
              color: ColorsPalette.white, fontSize: 30.0))),
            leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowLeft, color: ColorsPalette.lynxWhite),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);              
              })        ),
        body: SettingsView()
        ),
      )
    );
  }

  
}