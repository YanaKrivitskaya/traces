
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/notes/bloc/bloc.dart';

class SortOption{
  final SortOptions _key;
  final String _value;
  SortOption(this._key, this._value);
}
class OrderOption{
  final OrderOptions _key;
  final String _value;
  OrderOption(this._key, this._value);
}

class SortOrder{
  SortOptions _sortOption;
  OrderOptions _orderOption;
  SortOrder(this._sortOption, this._orderOption);
}

class NoteFilterButton extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    /*return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state){*/
        return IconButton(
          icon: Icon(Icons.sort),
          onPressed: (){
            showDialog(barrierDismissible: false, context: context,builder: (_) =>
            BlocProvider.value(
                value: context.bloc<NotesBloc>(),
                child: SortDialog())
            );
            /*showDialog(barrierDismissible: false, context: context,builder: (_) =>
                SortDialog(initialSortOption: state.sortOption, initialOrderOption: state.orderOption,) ).then((res){
              /*if(res != null) setState(() {
                _sortOption = res._sortOption;
                _orderOption = res._orderOption;
                _sortNotes();
              });*/
            });*/
          },
        );
      /*},
    );*/
  }
}

class SortDialog extends StatefulWidget {
  //NotesBloc _notesBloc;
  /*SortDialog({this.initialSortOption, this.initialOrderOption});

  final SortOptions initialSortOption;
  final OrderOptions initialOrderOption;*/

  @override
  _SortDialogState createState() => new _SortDialogState();
}

class _SortDialogState extends State<SortDialog>{
  SortOptions _selectedSortOption;
  OrderOptions _selectedOrderOption;

  NotesBloc _notesBloc;

  final _sortOptionsList = [
    SortOption(SortOptions.TITLE, "Title"),
    SortOption(SortOptions.DATECREATED, "Date Created"),
    SortOption(SortOptions.DATEMODIFIED, "Date Modified"),
  ];

  final _orderOptionsLst = [
    OrderOption(OrderOptions.ASC, "Ascending"),
    OrderOption(OrderOptions.DESC, "Descending")
  ];

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    _selectedSortOption = _notesBloc.state.sortOption;
    _selectedOrderOption = _notesBloc.state.orderOption;
  }

  @override
  Widget build(BuildContext context){

    return new AlertDialog(
      title: Text('Sort by'),
      actions: <Widget>[
        FlatButton(
          child: Text('Done'),
          onPressed: () {
            _notesBloc.add(UpdateSortOrder(_selectedOrderOption, _selectedSortOption));
            Navigator.pop(context, new SortOrder(_selectedSortOption, _selectedOrderOption));
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
            _sortOptions(),
            Divider(color: ColorsPalette.blueHorizon),
            _orderOptions()
          ],
        ),
      ),
    );


  }

  Widget _sortOptions() => new Column(
    children:
    _sortOptionsList.map((SortOption option) => RadioListTile(
      groupValue: _selectedSortOption,
      title: Text(option._value),
      value: option._key,
      onChanged: (val) {
        setState(() {
          _selectedSortOption = val;
        });
      },
    )).toList(),
    //]
  );

  Widget _orderOptions() => new Column(
    children:
    _orderOptionsLst.map((OrderOption option) => RadioListTile(
      groupValue: _selectedOrderOption,
      title: Text(option._value),
      value: option._key,
      onChanged: (val) {
        setState(() {
          _selectedOrderOption = val;
        });
      },
    )).toList(),
    //]
  );
}