import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../colorsPalette.dart';
import 'bloc/entry_exit/entry_exit_bloc.dart';
import 'model/entryExit.dart';
import 'model/visa.dart';

class EntryExitDeleteAlert extends StatelessWidget {
  final EntryExit entryExit;
  final Visa visa;

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
                Text('Entry: ${entryExit.entryCountry} - ${DateFormat.yMMMd().format(entryExit.entryDate)}'),
                entryExit.hasExit ? Text('Exit: ${entryExit.exitCountry} - ${DateFormat.yMMMd().format(entryExit.exitDate)}') : Container()
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
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.mazarineBlue)),
              onPressed: () {                
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}
