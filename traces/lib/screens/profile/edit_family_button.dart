import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/family_dialog.dart';
import 'package:traces/screens/profile/bloc/profile/bloc.dart';

class EditFamilyButton extends StatelessWidget {
  final int familyMemberPosition;

  EditFamilyButton(this.familyMemberPosition);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios, size: 15.0),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider.value(
              value: context.read<ProfileBloc>()..add(ShowFamilyDialog()),
              child: FamilyDialog(familyMemberPosition),
            )
        );
      },
    );
  }
}
