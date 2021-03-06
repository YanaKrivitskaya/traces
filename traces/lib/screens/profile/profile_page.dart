
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import 'bloc/profile/bloc.dart';
import 'profile_view.dart';

class ProfilePage extends StatelessWidget{
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) =>
      ProfileBloc()..add(GetProfile()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
          title: Text('Profile', style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: ColorsPalette.white, fontSize: 25.0))),
          backgroundColor: ColorsPalette.meditSea,
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft,color: ColorsPalette.lynxWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ProfileView(),
      ),
    );
  }
}