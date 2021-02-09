import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/screens/visas/shared.dart';
import 'package:traces/shared/state_types.dart';

class EntryExitDetailsView extends StatefulWidget {
  @override
  _EntryExitDetailsViewState createState() => _EntryExitDetailsViewState();
}

class _EntryExitDetailsViewState extends State<EntryExitDetailsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _entryCountryController;
  TextEditingController _entryCityController;
  TextEditingController _exitCountryController;
  TextEditingController _exitCityController;

  @override
  void initState() {
    super.initState();
    _entryCountryController = new TextEditingController();
    _entryCityController = new TextEditingController();
    _exitCountryController = new TextEditingController();
    _exitCityController = new TextEditingController();
  }

  @override
  void dispose() {
    _entryCountryController.dispose();
    _entryCityController.dispose();
    _exitCountryController.dispose();
    _exitCityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Entry/Exit record",style: GoogleFonts.quicksand(
                    textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
         // actions: [_deleteAction(state)],
        ),
        backgroundColor: Colors.white,
        body: BlocListener<EntryExitBloc, EntryExitState>(
          listener: (context, state) {
            if (state.status == StateStatus.Success && state.mode == StateMode.View) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: ColorsPalette.algalFuel,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 250, child: Text("Saved successfully",
                          style: GoogleFonts.quicksand(textStyle:TextStyle(color: ColorsPalette.lynxWhite)),
                          overflow: TextOverflow.ellipsis, maxLines: 2)),
                        Icon(Icons.info)
                      ])));
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);                
              });
            }
          },
          child: BlocBuilder<EntryExitBloc, EntryExitState>(
            builder: (context, state) {
              if (state.status == StateStatus.Loading) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorsPalette.algalFuel)));
              }
              if(state.status == StateStatus.Success && state.mode == StateMode.Edit){
                if(state.entryExit.id != null){
                  _entryCountryController.text = state.entryExit.entryCountry;
                  _entryCityController.text = state.entryExit.entryCity;
                  _exitCountryController.text = state.entryExit.exitCountry;
                  _exitCityController.text = state.entryExit.exitCity;
                }
                return Container(padding: EdgeInsets.all(10.0), color: ColorsPalette.white, child: SingleChildScrollView(
                  child: Form(key: this._formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    _entryEditContainer(context, state),
                    state.entryExit.id !=null ? _exitEditContainer(context, state) : Container(),
                    _submitButton(state)
                  ],)),
                ));
              }
              return Container();
            },
          ),
        ));
  }

Widget _deleteAction(EntryExitState state) => new IconButton(
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        onPressed: () {
          showDialog<String>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (_) => BlocProvider.value(
                    value: context.bloc<EntryExitBloc>(),
                    /*child: EnttyDeleteAlert(
                      visa: state.visa,
                      callback: (val) =>
                          val == 'Delete' ? Navigator.of(context).pop() : '',
                    ),*/
                  ));
        },
      );

Widget _entryEditContainer(BuildContext context, EntryExitState state) => new Column(
  crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
  Text('Entry', style: GoogleFonts.quicksand(
    textStyle: TextStyle(color: ColorsPalette.mazarineBlue,
      fontSize: 22.0,fontWeight: FontWeight.bold))),
  Divider(color: ColorsPalette.algalFuel),
  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
    Text('Date', style: TextStyle(fontSize: 16.0, color: ColorsPalette.mazarineBlue)),
    Text('${DateFormat.yMMMd().format(state.entryExit.entryDate)}', style: TextStyle(
          fontSize: 16.0,fontWeight: FontWeight.bold)),
    IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue), 
      onPressed: ()=> _selectEntryDate(context, state))
  ],),
  _entryCountrySelector(state), 
  _entryCitySelector(state),
  _entryTransportSelector(state)  
]);

Widget _exitEditContainer(BuildContext context, EntryExitState state) => new Container(
  padding: EdgeInsets.only(top: 15.0),
  child:Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
    Text('Exit', style: GoogleFonts.quicksand(
      textStyle: TextStyle(color: ColorsPalette.mazarineBlue,
        fontSize: 22.0,fontWeight: FontWeight.bold))),
    Divider(color: ColorsPalette.algalFuel),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      Text('Date', style: TextStyle(fontSize: 16.0, color: ColorsPalette.mazarineBlue)),
      Text('${DateFormat.yMMMd().format(state.entryExit.exitDate)}', style: TextStyle(
            fontSize: 16.0,fontWeight: FontWeight.bold)),
      IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue), 
        onPressed: ()=> _selectExitDate(context, state))
    ],),
    _exitCountrySelector(state), 
    _exitCitySelector(state),
    _exitTransportSelector(state)  
]));

  Future<Null> _selectEntryDate(
    BuildContext context, EntryExitState state) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child,
          );
        },
        context: context,
        initialDate: state.entryExit.entryDate ?? state.visa.startDate,
        firstDate: state.visa.startDate,
        lastDate: state.visa.endDate.add(new Duration(days: -1)));
    if (picked != null) {
      context.bloc<EntryExitBloc>().add(EntryDateChanged(picked));     
    }
  }

  Future<Null> _selectExitDate(
      BuildContext context, EntryExitState state) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child,
          );
        },
        context: context,
        initialDate: state.entryExit.exitDate ?? state.visa.startDate,
        firstDate: state.visa.startDate,
        lastDate: state.visa.endDate.add(new Duration(days: -1)));
    if (picked != null) {
      context.bloc<EntryExitBloc>().add(ExitDateChanged(picked));     
    }
  }

  Widget _entryCountrySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _entryCountryController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);

  Widget _exitCountrySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _exitCountryController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);

  Widget _entryCitySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'City',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _entryCityController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);

  Widget _exitCitySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'City',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _exitCityController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);
  
  Widget _entryTransportSelector(EntryExitState state) =>
      new DropdownButtonFormField<String>(
        value: state.entryExit.entryTransport??state.settings.transport.first,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Transport",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items:
            state.settings.transport.map((String value) {
          return new DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  transportIcon(value),
                  SizedBox(
                    width: 15.0,
                  ),
                  new Text(value),
                ],
              ));
        }).toList(),
        onChanged: (String value) {
          state.entryExit.entryTransport = value.trim();
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Widget _exitTransportSelector(EntryExitState state) =>
      new DropdownButtonFormField<String>(
        value: state.entryExit.exitTransport??state.settings.transport.first,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Transport",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items:
            state.settings.transport.map((String value) {
          return new DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  transportIcon(value),
                  SizedBox(
                    width: 15.0,
                  ),
                  new Text(value),
                ],
              ));
        }).toList(),
        onChanged: (String value) {
          state.entryExit.exitTransport = value.trim();
          //FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
    );

  Widget _submitButton(EntryExitState state) => new Center(
      child: Container(padding: EdgeInsets.only(top: 10.0),
        child: RaisedButton(child: Text('Save'),
          textColor: ColorsPalette.lynxWhite,
          color: ColorsPalette.algalFuel,
          onPressed: () {
            state.entryExit.entryCountry = _entryCountryController.text.trim();
            state.entryExit.entryCity = _entryCityController.text.trim();
            state.entryExit.exitCountry = _exitCountryController.text.trim();
            state.entryExit.exitCity = _exitCityController.text.trim();
            context.bloc<EntryExitBloc>().add(SubmitEntry(state.entryExit,state.visa));
  })));

}


