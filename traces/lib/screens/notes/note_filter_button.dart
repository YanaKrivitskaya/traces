
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/color_constants.dart';
import '../../shared/state_types.dart';
import 'bloc/note_bloc/bloc.dart';
import 'bloc/note_sort_bloc/bloc.dart';
import 'model/note.model.dart';

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
      icon: FaIcon(FontAwesomeIcons.sortAmountDown, color: ColorsPalette.lynxWhite),
      onPressed: (){
        showDialog(barrierDismissible: false, context: context,builder: (_) =>
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<NoteBloc>(),
                ),
                BlocProvider<NoteSortBloc>(
                  create: (context) => NoteSortBloc(),
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
  NoteBloc _noteBloc;
  NoteSortBloc _sortBloc;

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
    _noteBloc = BlocProvider.of<NoteBloc>(context);
    _sortBloc = BlocProvider.of<NoteSortBloc>(context);

    final currentState = _noteBloc.state;
    if(currentState.status == StateStatus.Success){
      _sortBloc.add(SortUpdated(currentState.sortField, currentState.sortDirection));
    }
  }

  @override
  Widget build(BuildContext context){

    return BlocBuilder<NoteSortBloc, NoteSortState>(
        builder: (context, state) {
          print(state.tempSortDirection);
          print(state.tempSortField);
          return new AlertDialog(
            title: Text('Sort by'),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  _noteBloc.add(UpdateSortFilter(state.tempSortField, state.tempSortDirection));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.greenGrass)
                ),
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

  Widget _sortOptions(NoteSortState state) => new Column(
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

  Widget _orderOptions(NoteSortState state) => new Column(
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