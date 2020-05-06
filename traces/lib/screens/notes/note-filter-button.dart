
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';

import 'sort_bloc/bloc.dart';

class SortField{
  final SortFields _key;
  final String _value;
  SortField(this._key, this._value);
}
class SortDirection{
  final SortDirections _key;
  final String _value;
  SortDirection(this._key, this._value);
}

class NoteFilterButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sort),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.bloc<NotesBloc>(),
                ),
                BlocProvider<SortBloc>(
                  create: (context) => SortBloc(),
                ),
              ],
              child: SortDialog(),
            )
        );
      },
    );
  }
}

class SortDialog extends StatefulWidget {

  @override
  _SortDialogState createState() => new _SortDialogState();
}

class _SortDialogState extends State<SortDialog>{
  NotesBloc _notesBloc;
  SortBloc _sortBloc;

  final _sortFieldsList = [
    SortField(SortFields.TITLE, "Title"),
    SortField(SortFields.DATECREATED, "Date Created"),
    SortField(SortFields.DATEMODIFIED, "Date Modified"),
  ];

  final _sortDirectionsLst = [
    SortDirection(SortDirections.ASC, "Ascending"),
    SortDirection(SortDirections.DESC, "Descending")
  ];

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _sortBloc = BlocProvider.of<SortBloc>(context);

    final currentState = _notesBloc.state;
    if(currentState is NotesLoadSuccess){
      _sortBloc.add(SortUpdated(currentState.sortField, currentState.sortDirection));
    }
  }

  @override
  Widget build(BuildContext context){

    return BlocBuilder<SortBloc, SortState>(
        builder: (context, state) {
          return new AlertDialog(
            title: Text('Sort by'),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _notesBloc.add(UpdateSortOrder(state.tempSortField, state.tempSortDirection));
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {Navigator.pop(context);},
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _sortOptions(state),
                  Divider(color: ColorsPalette.blueHorizon),
                  _orderOptions(state)
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _sortOptions(SortState state) => new Column(
    children:
    _sortFieldsList.map((SortField option) => RadioListTile(
      groupValue: state.tempSortField,
      title: Text(option._value),
      value: option._key,
      onChanged: (val) {
        _sortBloc.add(SortTempFieldUpdated(val));
      },
    )).toList(),
    //]
  );

  Widget _orderOptions(SortState state) => new Column(
    children:
    _sortDirectionsLst.map((SortDirection option) => RadioListTile(
      groupValue: state.tempSortDirection,
      title: Text(option._value),
      value: option._key,
      onChanged: (val) {
        _sortBloc.add(SortTempDirectionUpdated(val));
      },
    )).toList(),
    //]
  );
}