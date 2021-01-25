import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:traces/screens/visas/entry_exit_details_view.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/repository/firebase_visas_repository.dart';

class AddEntryButton extends StatelessWidget {
  final Visa visa;
  final EntryExit entryExit;
  final bool isEntryEdit;
  final bool isExitEdit;

  const AddEntryButton({Key key, this.visa, this.entryExit, this.isEntryEdit, this.isExitEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(
        'Add',
        style: TextStyle(color: ColorsPalette.mazarineBlue),
      ),
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => BlocProvider<EntryExitBloc>(
              create: (context) =>
                  EntryExitBloc(visasRepository: new FirebaseVisasRepository())
                    ..add(GetEntryDetails(entryExit, visa, isEntryEdit, isExitEdit)),
              child: /*AddEntryDialog(visa: visa),*/ EntryExitDetailsView()),
        );
      },
    );
  }
}
