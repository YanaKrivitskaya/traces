import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../colorsPalette.dart';
import '../bloc/entry_exit/entry_exit_bloc.dart';
import '../entry_exit_details_view.dart';
import '../model/entryExit.dart';
import '../model/visa.dart';
import '../repository/firebase_visas_repository.dart';

class AddEntryButton extends StatelessWidget {
  final Visa visa;
  final EntryExit entryExit;

  const AddEntryButton({Key key, this.visa, this.entryExit})
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
                    ..add(GetEntryDetails(entryExit, visa)),
              child: EntryExitDetailsView()),
        );
      },
    );
  }
}
