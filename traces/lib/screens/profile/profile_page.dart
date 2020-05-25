
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/profile/bloc/profile/bloc.dart';
import 'package:traces/screens/profile/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/repository/firebase_profile_repository.dart';

class ProfilePage extends StatelessWidget{
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) =>
      ProfileBloc(
          profileRepository: FirebaseProfileRepository()
      )
        ..add(GetProfile()),
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
          title: Text('Profile', style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: ColorsPalette.white, fontSize: 25.0))),
          backgroundColor: ColorsPalette.meditSea,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ProfileView(),
      ),
    );
  }
}