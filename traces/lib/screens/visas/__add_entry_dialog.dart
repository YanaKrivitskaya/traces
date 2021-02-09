import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/screens/visas/model/entryExit.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/shared/state_types.dart';
import 'package:intl/intl.dart';

class AddEntryDialog extends StatefulWidget {
  final Visa visa;

  AddEntryDialog({Key key, this.visa}) : super(key: key);

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  TextEditingController _countryController;
  TextEditingController _cityController;
  EntryExit entryExitModel = new EntryExit(entryDate: DateTime.now());

  @override
  void initState() {
    super.initState();
    _countryController = new TextEditingController();
    _cityController = new TextEditingController();
  }

  @override
  void dispose(){
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryExitBloc, EntryExitState>(
        listener: (context, state){
          /*if(state.mode == StateMode.Edit){
            if(state.entry == null){
              state.visa = new Visa(
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  entryExitIds: new List<String>());
            }else{
              _countryController.text = state.visa.countryOfIssue;
              _durationController.text = state.visa.durationOfStay.toString();
            }
          }*/

        },
      child: BlocBuilder<EntryExitBloc, EntryExitState>(
          builder: (context, state) {

            return new AlertDialog(
                title: Column(children:[
                  Text('Visa entry'),
                  Divider(color: ColorsPalette.algalFuel)
                ]),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Done'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: ColorsPalette.mazarineBlue,
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: ColorsPalette.mazarineBlue,
                  ),
                ],
                content: Container(
                  child: Column(
                    children: <Widget>[
                      //_addSearchTagField(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Entry Date", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text('${DateFormat.yMMMd().format(entryExitModel.entryDate)}'/*, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)*/),
                                    IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue,), onPressed: () => _selectEntryDate(context, state),),
                                  ],)
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Entry Country", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  _countrySelector(state)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Entry City", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  _citySelector(state)
                                ],
                              ),
                            ),
                            //IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue,), onPressed: () => _selectEntryDate(context, state),),
                            /*state.status == StateStatus.Success && _tags.length > 0
                              ? _tagOptions()
                              : state.status == StateStatus.Loading
                              ? Center(child: CircularProgressIndicator(),)
                              : Text("No tags found")*/
                          ],),),
                      )],),)
            );
          }),
    );
  }

  Future<Null> _selectEntryDate(BuildContext context, EntryExitState state) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
                primarySwatch: ColorsPalette.matVisaCalendarColor
            ),
            child: child,
          );
        },
        context: context,
        initialDate: widget.visa.startDate,
        firstDate: widget.visa.startDate,
        lastDate: widget.visa.endDate
    );
    if (picked != null/* && picked != state.visa.startDate*/){
      entryExitModel.entryDate = picked;
      /*state.visa.durationOfStay = int.parse(this._durationController.text.trim());
      context.bloc<VisaDetailsBloc>().add(DateFromChanged(picked));*/
    }
  }

  Widget _countrySelector(EntryExitState state) => new TextFormField(
      /*decoration: const InputDecoration(
          labelText: 'Entry Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
      ),*/
      controller: _countryController,
      //autovalidate: _autovalidate,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text
  );

  Widget _citySelector(EntryExitState state) => new TextFormField(
      /*decoration: const InputDecoration(
          labelText: 'Entry Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
      ),*/
      controller: _cityController,
      //autovalidate: _autovalidate,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text
  );

}