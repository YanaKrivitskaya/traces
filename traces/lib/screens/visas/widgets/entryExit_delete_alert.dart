import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/visas/model/visa.model.dart';
import 'package:traces/screens/visas/model/visa_entry.model.dart';
import '../../../constants/color_constants.dart';
import '../bloc/entry_exit/visa_entry_bloc.dart';
import '../model/entryExit.dart';

class EntryExitDeleteAlert extends StatelessWidget {
  final VisaEntry? entryExit;
  final Visa? visa;

  const EntryExitDeleteAlert({Key? key, this.entryExit, this.visa/*, this.callback*/}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisaEntryBloc, VisaEntryState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        return AlertDialog(
          title: Text("Delete Entry/Exit record?"),
          content: SingleChildScrollView(            
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                Text('Entry: ${entryExit!.entryCountry} - ${DateFormat.yMMMd().format(entryExit!.entryDate)}'),
                entryExit!.hasExit! ? Text('Exit: ${entryExit!.exitCountry} - ${DateFormat.yMMMd().format(entryExit!.exitDate!)}') : Container()
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.mazarineBlue)),
              onPressed: () {
                context.read<VisaEntryBloc>().add(DeleteEntry(entryExit, visa));
                //callback("Delete");
                Navigator.pop(context);
              },
            ),
            TextButton(
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
