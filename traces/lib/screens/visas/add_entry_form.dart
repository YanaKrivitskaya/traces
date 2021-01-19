import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/entry_exit/entry_exit_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/visas/shared.dart';

class AddEntryForm extends StatefulWidget {

  AddEntryForm({Key key}) : super(key: key);

  @override
  _AddEntryFormState createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  TextEditingController _countryController;
  TextEditingController _cityController;
  bool _autovalidate = false;

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
    return new Scaffold(
      appBar: AppBar(
          title: Text('Visa Entry', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          )
      ),
      backgroundColor: Colors.white,
      body: BlocListener<EntryExitBloc, EntryExitState>(
          listener: (context, state){
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

            /*if(state.status == StateStatus.Created){
              Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
                SnackBar(
                  backgroundColor: ColorsPalette.algalFuel,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                          "Entry created successfully",
                          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Icon(Icons.info)],
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.popAndPushNamed(context, visaDetailsRoute, arguments: widget.visa.id);
              });
            }
            _autovalidate = state.autovalidate;*/
          },
          child: BlocBuilder<EntryExitBloc, EntryExitState>(builder: (context, state){
            if (state is LoadingEntryDetailsState) {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.algalFuel)));
            }
            if(state is EditDetailsState){
              return Container(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                      color: ColorsPalette.white,
                      padding: EdgeInsets.all(15.0),
                      //height: MediaQuery.of(context).size.height * 0.6,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Entry', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.mazarineBlue, fontSize: 22.0, fontWeight: FontWeight.bold))),
                            Divider(color: ColorsPalette.algalFuel),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text("Date", style: TextStyle(fontSize: 16.0, color: ColorsPalette.mazarineBlue)),
                              Text('${DateFormat.yMMMd().format(state.entry.entryDate)}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                              IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue,), onPressed: () => _selectEntryDate(context, state),),
                            ],),
                            /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: _countrySelector(state),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(top: 3.0),
                            child: _citySelector(state),
                          ),
                        ],),*/
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text("Entry Country", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  _countrySelector(state)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text("Entry City", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                  _citySelector(state)
                                ],
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
                            //Divider(color: ColorsPalette.algalFuel),
                            _submitButton(state)
                          ],
                        ),
                      )
                  )
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          })
      )
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
        initialDate: (state as EditDetailsState).visa.startDate,
        firstDate: (state as EditDetailsState).visa.startDate,
        lastDate: (state as EditDetailsState).visa.endDate.add(new Duration(days: -1))
    );
    if (picked != null/* && picked != state.visa.startDate*/){
      (state as EditDetailsState).entry.entryDate = picked;
      /*state.visa.durationOfStay = int.parse(this._durationController.text.trim());
      context.bloc<VisaDetailsBloc>().add(DateFromChanged(picked));*/
    }
  }

  Widget _countrySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Country',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
      ),
      controller: _countryController,
      //autovalidate: _autovalidate,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text
  );

  Widget _citySelector(EntryExitState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'City',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
      ),
      controller: _cityController,
      //autovalidate: _autovalidate,
      validator: (value) {
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.text
  );

  Widget _transportSelector(EntryExitState state) => new DropdownButtonFormField<String>(
    //value: state.entry.numberOfEntries,
    isExpanded: true,
    decoration: InputDecoration(
        labelText: "Transport",
        labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
    ),
    items: (state as EditDetailsState).settings.transport.map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: Row(children: [
          transportIcon(value),
          SizedBox(width: 15.0,),
          new Text(value),
        ],)
      );
    }).toList(),
    onChanged: (String value) {
      //state.visa.numberOfEntries = value;
      FocusScope.of(context).unfocus();
      //context.bloc<FamilyBloc>().add(GenderUpdated(gender: value));
    },
    autovalidate: _autovalidate,
    validator: (value) {
      return value == null ? 'Required field' : null;
    },
  );

  Widget _submitButton(EntryExitState state) => new Center(
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
          child:RaisedButton(
              child: Text('Save'),
              textColor: ColorsPalette.lynxWhite,
              color: ColorsPalette.algalFuel,
              onPressed: (){
                /*var isFormValid = _formKey.currentState.validate();

            state.visa.countryOfIssue = _countryController.text.trim();
            state.visa.durationOfStay = int.parse(this._durationController.text.trim());

            context.bloc<VisaDetailsBloc>().add(VisaSubmitted(state.visa, isFormValid));*/
              })
      )
  );
}