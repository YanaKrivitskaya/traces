import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/color_constants.dart';
import 'bloc/profile/profile_bloc.dart';
import 'family_dialog.dart';

class AddFamilyButton extends StatelessWidget {
   final int groupId;

  const AddFamilyButton(this.groupId);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text("Add", style: TextStyle(color: ColorsPalette.fusionRed),),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider.value(
              value: context.read<ProfileBloc>(),
              child: FamilyDialog(null, groupId),
            )
        );
      },
    );
  }
}




