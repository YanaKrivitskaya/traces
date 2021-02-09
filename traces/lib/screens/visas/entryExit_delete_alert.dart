import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryExitDeleteAlert extends StatelessWidget {
  final EntryExit entryExit;
  final Visa visa;
  //final StringCallback callback;

  const EntryExitDeleteAlert({Key key, this.entryExit, this.visa/*, this.callback*/}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryExitBloc, EntryExitState>(
      cubit: BlocProvider.of(context),
      builder: (context, state){
        return AlertDialog(
          title: Text("Delete Entry/Exit record?"),
          content: SingleChildScrollView(            
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Entry: ${entryExit.entryCountry} - ${entryExit.entryDate}'),
                entryExit.hasExit ? Text('Exit: ${entryExit.exitCountry} - ${entryExit.exitDate}') : Container()
              ],
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.mazarineBlue)),
              onPressed: () {
                context.bloc<EntryExitBloc>().add(DeleteEntry(entryExit, visa));
                //callback("Delete");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.mazarineBlue),),
              onPressed: () {
                //callback("Cancel");
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}
