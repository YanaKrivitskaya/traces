import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/visas/add_entry_dialog.dart';
import 'package:traces/screens/visas/add_entry_form.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/firebase_visas_repository.dart';

class AddEntryButton extends StatelessWidget {
  final Visa visa;

  const AddEntryButton({Key key, this.visa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text('Add', style: TextStyle(color: ColorsPalette.mazarineBlue),),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider<EntryExitBloc>(
              create: (context) => EntryExitBloc(visasRepository: new FirebaseVisasRepository())..add(GetEntryDetails(null, visa)),
              child: /*AddEntryDialog(visa: visa),*/ AddEntryForm()
            ),
        );
      },
    );
  }
}
