import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/services/shared_preferencies_service.dart';
import '../model/trip.model.dart';
import '../trip_view_options/bloc/tripviewoptions_bloc.dart';


class ViewOptionItem{
  final int _key;
  final String _value;
  ViewOptionItem(this._key, this._value);
}
class UpdateTripViewDialog extends StatefulWidget {
  
  const UpdateTripViewDialog({Key? key}) : super(key: key);

   @override
  _UpdateTripViewDialogState createState() => new _UpdateTripViewDialogState();
}

class _UpdateTripViewDialogState extends State<UpdateTripViewDialog>{
  final _viewOptionsList = [
    ViewOptionItem(1, "Comfy"),
    ViewOptionItem(2, "Compact")
  ];
  //SharedPreferencesService sharedPrefsService = SharedPreferencesService();

  String tripsViewKey = "tripsViewOption";  

  @override
  Widget build(BuildContext context) {
    //int? selectedValue = sharedPrefsService.readInt(key: tripsViewKey) ?? 1;

    return new BlocBuilder<TripViewOptionsBloc, TripViewOptionsState>(
      builder:  (context, state) {
        return new AlertDialog(
            title: Text('Trips view'),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  //_noteBloc.add(UpdateSortFilter(state.tempSortField, state.tempSortDirection));
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
                  _viewOptions(context, state),                  
                ],
              ),
            ),
          );
      },
    );
    
  }

  Widget _viewOptions(BuildContext context, TripViewOptionsState state) => new Column(
    children:
    _viewOptionsList.map((ViewOptionItem option) => RadioListTile(
      groupValue: state.activeOption,
      title: Text(option._value),
      value: option._key,
      onChanged: (dynamic val) {
        context.read<TripViewOptionsBloc>().add(ViewOptionUpdated(val));
      },
    )).toList(),
    //]
  );

}