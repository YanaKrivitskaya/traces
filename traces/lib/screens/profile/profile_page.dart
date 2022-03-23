
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import 'bloc/profile/bloc.dart';
import 'name_edit_button.dart';
import 'profile_view.dart';

class ProfilePage extends StatelessWidget{
  ProfilePage();

  @override
  Widget build(BuildContext context) {    
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
          centerTitle: true,
          title: Text('Profile', style: GoogleFonts.quicksand(textStyle: 
              TextStyle(fontSize: 30.0, color: ColorsPalette.black))),          
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [            
            (state.profile != null) ? NameEditButton(userId: state.profile!.userId) : Container()
          ],
          elevation: 0,
          backgroundColor: ColorsPalette.white
        ),
        body: ProfileView(),
      );}     
    );
  }
}