import 'package:flutter/material.dart';
import 'package:traces/screens/profile/bloc/family/family_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/family_dialog.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/repository/firebase_profile_repository.dart';

class EditFamilyButton extends StatelessWidget {
  final Family familyMember;

  EditFamilyButton(this.familyMember);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios, size: 15.0),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider<FamilyBloc>(
              create: (context) => FamilyBloc(profileRepository: FirebaseProfileRepository())..add(EditMode(familyMember: familyMember)),
              child: FamilyDialog(),
            ),
        );
      },
    );
  }
}
