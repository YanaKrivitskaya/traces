import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/visas/bloc/visa_details/visa_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisaEditView extends StatefulWidget {
  VisaEditView({Key key}) : super(key: key);

  @override
  _VisaEditViewState createState() => _VisaEditViewState();
}

class _VisaEditViewState extends State<VisaEditView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _countryController;
  TextEditingController _durationController;

  String _selectedType;
  String _selectedEntriesNumber;
  String _selectedOwner;

  DateTime dateValidFrom = DateTime.now();
  DateTime dateValidTo = DateTime.now();

  bool _isEditMode = false;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _countryController = new TextEditingController();
    _durationController = new TextEditingController();
  }

  @override
  void dispose(){
    _countryController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text('New Visa', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
        backgroundColor: ColorsPalette.mazarineBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        )
      ),

      body: BlocListener<VisaDetailsBloc, VisaDetailsState>(
        listener: (context, state){
          if(state.isFailure){
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
          }
          if(state.isLoading && state.isEditing){
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
          }
          if(state.isSuccess){
            Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
              SnackBar(
                backgroundColor: ColorsPalette.algalFuel,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        "Visa created successfully", style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.info)],
                ),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          }
          if(state.isEditing){
            if(state.familyMembers.length == 1) {
              this._selectedOwner = state.familyMembers.first;
            }
          }

          _autovalidate = state.autovalidate;
          print("autovalidate");
          print(state.autovalidate);
        },
        child: BlocBuilder<VisaDetailsBloc, VisaDetailsState>(builder: (context, state){
          if (state.isLoading && !state.isEditing) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorsPalette.algalFuel)));
          }
          if(state.isEditing || state.isSuccess || state.isFailure){
            return Container(
                padding: EdgeInsets.all(5.0),
                child: _createForm(state)
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        })
      ),
      backgroundColor: Colors.white,
    );
  }


  Widget _createForm(VisaDetailsState state) => new Container(
    color: ColorsPalette.white,
    padding: EdgeInsets.all(15.0),
    //height: MediaQuery.of(context).size.height * 0.6,
    child: SingleChildScrollView(
        child: Form(
          key: this._formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            _ownerSelector(state),
            _countrySelector(state),
            _typeSelector(state),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: _entriesNumberSelector(state),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(top: 3.0),
                  child: _durationSelector(state),
                ),
              ],
            ),
            /*_entriesNumberSelector(state),
                    _durationSelector(state),*/
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Text("Start date", style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue),),
                SizedBox(height: 30.0),
                Text("End date", style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue),),
              ],),
              Column(children: <Widget>[
                Text('${DateFormat.yMMMd().format(dateValidFrom)}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 30.0),
                Text('${DateFormat.yMMMd().format(dateValidTo)}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              ],),
              Column(children: <Widget>[
                IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue,), onPressed: () => _selectValidFromDate(context),),
                IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue,), onPressed: () => _selectValidToDate(context),)
              ],),
            ],),
            Divider(color: ColorsPalette.algalFuel),
            _submitButton(state)
          ],),
        )
    )
  );

  /*Validations:

  -- Owner should be selected
  -- Country should be selected
  -- Type should be selected
  -- Entries should be selected
  -- Duration of stay should be entered
  -- End date should be greater than start date

   */

  Widget _submitButton(VisaDetailsState state) => new Center(
    child:RaisedButton(
      child: Text("Create visa"),
      textColor: ColorsPalette.lynxWhite,
      color: ColorsPalette.algalFuel,
      onPressed: (){
        var isFormValid = _formKey.currentState.validate();

        print("isFormValid");
        print(isFormValid);

        Visa visaToSave = new Visa(
          this.dateValidFrom,
          this.dateValidTo,
          this._countryController.text.trim(),
          this._durationController.text.trim(),
          this._selectedEntriesNumber,
          this._selectedOwner,
          type: this._selectedType,
          entryExitIds: new List<String>());

        context.bloc<VisaDetailsBloc>().add(VisaSubmitted(visaToSave, isFormValid));
        //Navigator.pop(context);
      })
  );

  Widget _ownerSelector(VisaDetailsState state) => new DropdownButtonFormField<String>(
    value: _selectedOwner,
    isExpanded: true,
    decoration: InputDecoration(
        labelText: "Visa owner",
        labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
    ),
    items: state.familyMembers.map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList(),
    onChanged: (String value) {
      this._selectedOwner = value;
      //context.bloc<FamilyBloc>().add(GenderUpdated(gender: value));
    },
    autovalidate: _autovalidate,
    validator: (value) {
      return value == null ? 'Required field' : null;
    }
    );

  Widget _countrySelector(VisaDetailsState state) => new TypeAheadFormField(
    textFieldConfiguration: TextFieldConfiguration(
        controller: this._countryController,
        decoration: InputDecoration(
            labelText: 'Country of issue',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
        ),
    ),
    // ignore: missing_return
    suggestionsCallback: (pattern) {
      if(pattern.isNotEmpty){
        var filteredCountries = state.userCountries.countries.where((c) => c.toLowerCase().startsWith(pattern.toLowerCase())).toList();
        if(filteredCountries.length > 0){
          return filteredCountries;
        }
      }
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    transitionBuilder: (context, suggestionsBox, controller) {
      return suggestionsBox;
    },
    onSuggestionSelected: (suggestion) {
      this._countryController.text = suggestion;
      FocusScope.of(context).unfocus();
    },
    autovalidate: _autovalidate,
    validator: (value) {
      if (value.isEmpty) {
        return 'Required field';
      }
      return null;
    }
  );

  Widget _durationSelector(VisaDetailsState state) => new TextFormField(
    decoration: const InputDecoration(
        labelText: 'Duration of stay',
        labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
    ),
    controller: _durationController,
    autovalidate: _autovalidate,
    validator: (value) {
      return value.isEmpty ? 'Required field' : null;
    },
    keyboardType: TextInputType.number
  );

  Widget _typeSelector(VisaDetailsState state) => new DropdownButtonFormField<String>(
    value: _selectedType,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: "Type",
      labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
    ),
    items: state.settings.visaTypes.map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList(),
    onChanged: (String value) {
      this._selectedType = value;
      FocusScope.of(context).unfocus();
    },
    autovalidate: _autovalidate,
    validator: (value) {
      return value == null ? 'Required field' : null;
    },
  );

  Widget _entriesNumberSelector(VisaDetailsState state) => new DropdownButtonFormField<String>(
    value: _selectedEntriesNumber,
    isExpanded: true,
    decoration: InputDecoration(
        labelText: "Entries",
        labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)
    ),
    items: state.settings.entries.map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList(),
    onChanged: (String value) {
      this._selectedEntriesNumber = value;
      FocusScope.of(context).unfocus();
      //context.bloc<FamilyBloc>().add(GenderUpdated(gender: value));
    },
    autovalidate: _autovalidate,
    validator: (value) {
      return value == null ? 'Required field' : null;
    },
  );

  Future<Null> _selectValidFromDate(BuildContext context) async {
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
        initialDate: dateValidFrom,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateValidFrom)
      //TODO: add event DateFromChanged
      setState(() {
        dateValidFrom = picked;
      });
  }

  Future<Null> _selectValidToDate(BuildContext context) async {
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
        initialDate: dateValidTo,
        firstDate: DateTime(2010, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateValidTo)
      //TODO: add event DateToChanged
      setState(() {
        dateValidTo = picked;
      });
  }

}