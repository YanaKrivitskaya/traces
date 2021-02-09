import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/bloc/profile/profile_bloc.dart';
import 'package:traces/screens/profile/family_dialog.dart';

class AddFamilyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text("Add", style: TextStyle(color: ColorsPalette.fusionRed),),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider.value(
              value: context.bloc<ProfileBloc>(),
              child: FamilyDialog(null),
            )
        );
      },
    );
  }
}




