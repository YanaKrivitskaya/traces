import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/visas/shared.dart';

/*class AddEntryForm extends StatefulWidget {
  final String formName;
  const AddEntryForm({Key key, this.formName}) : super(key: key);

  @override
  _AddEntryFormState createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _entryCountryController;
  TextEditingController _entryCityController;
  TextEditingController _exitCountryController;
  TextEditingController _exitCitycityController;

  @override
  void initState() {
    super.initState();
    _entryCountryController = new TextEditingController();
    _entryCityController = new TextEditingController();
    _exitCountryController = new TextEditingController();
    _exitCitycityController = new TextEditingController();
  }

  @override
  void dispose() {
    _entryCountryController.dispose();
    _entryCityController.dispose();
    _exitCountryController.dispose();
    _exitCitycityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text(widget.formName,
                style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                        color: ColorsPalette.lynxWhite, fontSize: 25.0))),
            backgroundColor: ColorsPalette.mazarineBlue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            )),
        backgroundColor: Colors.white,
        body: BlocListener<EntryExitBloc, EntryExitState>(
            listener: (context, state) {
          /*if(state.status == StateStatus.Error){
              Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.redPigment,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          state.errorMessage, style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Icon(Icons.error)],
                  ),
                ),
              );
            }*/
          /*if(state is LoadingEntryDetailsState){
              Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.algalFuel,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.lynxWhite),),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ],
                  ),
                ),
              );
            }*/

          if (state is SuccessEntryDetailsState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.algalFuel,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          "Entry created successfully",
                          style: GoogleFonts.quicksand(
                              textStyle:
                                  TextStyle(color: ColorsPalette.lynxWhite)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Icon(Icons.info)
                    ],
                  ),
                ),
              );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.popAndPushNamed(context, visaDetailsRoute,
                  arguments: state.visa.id);
            });
          }
          //_autovalidate = state.autovalidate;
        }, child: BlocBuilder<EntryExitBloc, EntryExitState>(
                builder: (context, state) {
          if (state is LoadingEntryDetailsState) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        ColorsPalette.algalFuel)));
          }
          if (state is SuccessEntryDetailsState) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        ColorsPalette.algalFuel)));
          }
          if (state is EditDetailsState) {
            return Container(
                padding: EdgeInsets.all(5.0),
                child: Container(
                    color: ColorsPalette.white,
                    padding: EdgeInsets.all(15.0),
                    //height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                        child: Form(
                      key: this._formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Entry',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: ColorsPalette.mazarineBlue,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold))),
                          Divider(color: ColorsPalette.algalFuel),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: ColorsPalette.mazarineBlue)),
                              Text(
                                  '${DateFormat.yMMMd().format(state.entry.entryDate)}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  color: ColorsPalette.mazarineBlue,
                                ),
                                onPressed: () =>
                                    _selectEntryDate(context, state),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [_countrySelector(state)],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [_citySelector(state)],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text("Entry City", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                _transportSelector(state),
                              ],
                            ),
                          ),
                          /*(state.entry.entryCountry != null)
                              ? Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text('Exit',
                                        style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                color:
                                                    ColorsPalette.mazarineBlue,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold))),
                                    Divider(color: ColorsPalette.algalFuel),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Date",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: ColorsPalette
                                                    .mazarineBlue)),
                                        Text(
                                            '${DateFormat.yMMMd().format(state.entry.exitDate)}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: ColorsPalette.mazarineBlue,
                                          ),
                                          onPressed: () =>
                                              _selectExitDate(context, state),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [_countrySelector(state)],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [_citySelector(state)],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Text("Entry City", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                          _transportSelector(state),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),*/
                          _submitButton(state)
                        ],
                      ),
                    ))));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        })));
  }

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
        initialDate: (state as EditDetailsState).visa.startDate,
        firstDate: (state as EditDetailsState).visa.startDate,
        lastDate: (state as EditDetailsState)
            .visa
            .endDate
            .add(new Duration(days: -1)));
    if (picked != null /* && picked != state.visa.startDate*/) {
      (state as EditDetailsState).entry.entryDate = picked;
      /*state.visa.durationOfStay = int.parse(this._durationController.text.trim());
      context.bloc<VisaDetailsBloc>().add(DateFromChanged(picked));*/
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
        initialDate: (state as EditDetailsState).entry.entryDate,
        firstDate: (state as EditDetailsState).entry.entryDate,
        lastDate: (state as EditDetailsState)
            .visa
            .endDate
            .add(new Duration(days: -1)));
    if (picked != null) {
      (state as EditDetailsState).entry.exitDate = picked;
      /*state.visa.durationOfStay = int.parse(this._durationController.text.trim());
      context.bloc<VisaDetailsBloc>().add(DateFromChanged(picked));*/
    }
  }

  Widget _countrySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _entryCountryController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);

  Widget _citySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'City',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _entryCityController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text);

  Widget _transportSelector(EntryExitState state) =>
      new DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Transport",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items:
            (state as EditDetailsState).settings.transport.map((String value) {
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
          (state as EditDetailsState).entry.entryTransport = value.trim();
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Widget _submitButton(EntryExitState state) => new Center(
      child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: RaisedButton(
              child: Text('Save'),
              textColor: ColorsPalette.lynxWhite,
              color: ColorsPalette.algalFuel,
              onPressed: () {
                (state as EditDetailsState).entry.entryCountry =
                    _entryCountryController.text.trim();
                (state as EditDetailsState).entry.entryCity =
                    _entryCityController.text.trim();

                context.bloc<EntryExitBloc>().add(SubmitEntry(
                    (state as EditDetailsState).entry,
                    (state as EditDetailsState).visa));
              })));
}*/
