import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/error_widgets.dart';
import 'package:traces/widgets/widgets.dart';

import '../../constants/color_constants.dart';
import '../../utils/misc/state_types.dart';
import 'bloc/visa_entry/visa_entry_bloc.dart';
import 'helpers.dart';
import 'model/visa_settings.model.dart';

class VisaEntryDetailsView extends StatefulWidget {
  @override
  _VisaEntryDetailsViewState createState() => _VisaEntryDetailsViewState();
}

class _VisaEntryDetailsViewState extends State<VisaEntryDetailsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _entryCountryController;
  TextEditingController? _entryCityController;
  TextEditingController? _exitCountryController;
  TextEditingController? _exitCityController;

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
    _entryCountryController!.dispose();
    _entryCityController!.dispose();
    _exitCountryController!.dispose();
    _exitCityController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Visa Entry",style: quicksandStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0)),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: ColorsPalette.lynxWhite),
            onPressed: () => Navigator.of(context).pop(),
        )),
        backgroundColor: Colors.white,
        body: BlocListener<VisaEntryBloc, VisaEntryState>(
          listener: (context, state) {
            if (state.status == StateStatus.Success && state.mode == StateMode.View) {
              ScaffoldMessenger.of(context)
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
                        Icon(Icons.info, color: ColorsPalette.white)
                      ])));
              Future.delayed(const Duration(seconds: 1), () {                
                Navigator.pop(context);                
              });
            }
            if (state.status == StateStatus.Error && state.visaEntry != null) {
              ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: ColorsPalette.redPigment,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        state.exception.toString(),
                        style: quicksandStyle(color: ColorsPalette.lynxWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.error, color: ColorsPalette.lynxWhite)
                  ],
                ),
              ),
            );              
            }
            if(state.status == StateStatus.Success && state.mode == StateMode.Edit){
                if(state.visaEntry!.id != null){
                  if(_entryCountryController!.text == '') _entryCountryController!.text = state.visaEntry!.entryCountry!;
                  if(_entryCityController!.text == '') _entryCityController!.text = state.visaEntry!.entryCity ?? '';
                  if(_exitCountryController!.text == '') _exitCountryController!.text = state.visaEntry!.exitCountry ?? '';
                  if(_exitCityController!.text == '') _exitCityController!.text = state.visaEntry!.exitCity ?? '';                  
                  if(state.visaEntry!.exitDate == null) state.visaEntry = state.visaEntry!.copyWith(exitDate: state.visaEntry!.entryDate);
                }                
              }
          },
          child: BlocBuilder<VisaEntryBloc, VisaEntryState>(
            builder: (context, state) {
              if (state.status == StateStatus.Loading) {
                return loadingWidget(ColorsPalette.algalFuel);
              }
              if (state.status == StateStatus.Error && state.visaEntry == null) {
                return errorWidget(context, error: state.exception!);
              }
              if(state.status == StateStatus.Success && state.mode == StateMode.Edit){                
                return Container(padding: EdgeInsets.all(10.0), color: ColorsPalette.white, child: SingleChildScrollView(
                  child: Form(key: this._formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    _entryEditContainer(context, state),
                    state.visaEntry!.id !=null ? _exitEditContainer(context, state) : Container(),
                    _submitButton(state)
                  ],)),
                ));
              }
              return Container();
            },
          ),
        ));
  }

Widget _entryEditContainer(BuildContext context, VisaEntryState state) => new Column(
  crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
  Text('Entry', style: GoogleFonts.quicksand(
    textStyle: TextStyle(color: ColorsPalette.mazarineBlue,
      fontSize: 22.0,fontWeight: FontWeight.bold))),
  Divider(color: ColorsPalette.algalFuel),
  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
    Text('Date', style: TextStyle(fontSize: 16.0, color: ColorsPalette.mazarineBlue)),
    Text('${DateFormat.yMMMd().format(state.visaEntry!.entryDate)}', style: TextStyle(
          fontSize: 16.0,fontWeight: FontWeight.bold)),
    IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue), 
      onPressed: ()=> _selectEntryDate(context, state))
  ],),
  _entryCountrySelector(state), 
  _entryCitySelector(state),
  _entryTransportSelector(state)  
]);

Widget _exitEditContainer(BuildContext context, VisaEntryState state) => new Container(
  padding: EdgeInsets.only(top: 15.0),
  child:Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
    Text('Exit', style: GoogleFonts.quicksand(
      textStyle: TextStyle(color: ColorsPalette.mazarineBlue,
        fontSize: 22.0,fontWeight: FontWeight.bold))),
    Divider(color: ColorsPalette.algalFuel),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      Text('Date', style: TextStyle(fontSize: 16.0, color: ColorsPalette.mazarineBlue)),
      Text('${DateFormat.yMMMd().format(state.visaEntry!.exitDate!)}', style: TextStyle(
            fontSize: 16.0,fontWeight: FontWeight.bold)),
      IconButton(icon: FaIcon(FontAwesomeIcons.calendarAlt, color: ColorsPalette.mazarineBlue), 
        onPressed: ()=> _selectExitDate(context, state))
    ],),
    _exitCountrySelector(state), 
    _exitCitySelector(state),
    _exitTransportSelector(state)  
]));

  Future<Null> _selectEntryDate(
    BuildContext context, VisaEntryState state) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child!,
          );
        },
        context: context,
        initialDate: state.visaEntry!.entryDate,
        firstDate: state.visa!.startDate!,
        lastDate: DateTime.now().difference(state.visa!.endDate!).inDays > 0 ? state.visa!.endDate! : DateTime.now());
    if (picked != null) {
      context.read<VisaEntryBloc>().add(EntryDateChanged(picked));     
    }
  }

  Future<Null> _selectExitDate(
      BuildContext context, VisaEntryState state) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child!,
          );
        },
        context: context,
        initialDate: state.visaEntry!.exitDate ?? state.visaEntry!.entryDate,
        firstDate: state.visaEntry!.entryDate,
        lastDate: DateTime.now().difference(state.visa!.endDate!).inDays > 0 ? state.visa!.endDate! : DateTime.now());
    if (picked != null) {
      context.read<VisaEntryBloc>().add(ExitDateChanged(picked));     
    }
  }
  
   Widget _entryCountrySelector(VisaEntryState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._entryCountryController,
        decoration: InputDecoration(
            labelText: 'Country',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      ),
      // ignore: missing_return
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          /*var filteredCountries = state.userSettings!.countries!
              .where((c) => c.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
          if (filteredCountries.length > 0) {
            return filteredCountries;
          }*/
          return List.empty();
        }
        return List.empty();
      },
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._entryCountryController!.text = suggestion;
        FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });

  Widget _exitCountrySelector(VisaEntryState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._exitCountryController,
        decoration: InputDecoration(
            labelText: 'Country',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      ),
      // ignore: missing_return
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          /*var filteredCountries = state.userSettings!.countries!
              .where((c) => c.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
          if (filteredCountries.length > 0) {
            return filteredCountries;
          }*/
          return List.empty();
        }
        return List.empty();
      },
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._exitCountryController!.text = suggestion;
        FocusScope.of(context).unfocus();
      });

  Widget _entryCitySelector(VisaEntryState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._entryCityController,
        decoration: InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      ),
      // ignore: missing_return
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          /*var filteredCities = state.userSettings!.cities!
              .where((c) => c.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
          if (filteredCities.length > 0) {
            return filteredCities;
          }*/
          return List.empty();
        }
         return List.empty();
      },
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._entryCityController!.text = suggestion;
        FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });

  Widget _exitCitySelector(VisaEntryState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._exitCityController,
        decoration: InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      ),
      // ignore: missing_return
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          /*var filteredCities = state.userSettings!.cities!
              .where((c) => c.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
          if (filteredCities.length > 0) {
            return filteredCities;
          }*/
          return List.empty();
        }
        return List.empty();
      },
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._exitCityController!.text = suggestion;
        FocusScope.of(context).unfocus();
      });
  
  Widget _entryTransportSelector(VisaEntryState state) =>
      new DropdownButtonFormField<String>(
        value: state.visaEntry!.entryTransport,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Transport",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items:
            VisaSettings.transport.map((String value) {
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
        onChanged: (String? value) {
          state.visaEntry = state.visaEntry!.copyWith(entryTransport: value);
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Widget _exitTransportSelector(VisaEntryState state) =>
      new DropdownButtonFormField<String>(
        value: state.visaEntry!.exitTransport,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Transport",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items:
            VisaSettings.transport.map((String value) {
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
        onChanged: (String? value) {
          state.visaEntry = state.visaEntry!.copyWith(exitTransport: value);
          FocusScope.of(context).unfocus();
        },        
    );

  Widget _submitButton(VisaEntryState state) => new Center(
      child: Container(padding: EdgeInsets.only(top: 10.0),
        child: ElevatedButton(child: Text('Save'),
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
            backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.algalFuel),
            foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.lynxWhite)
          ),         
          onPressed: () {
            var isFormValid = _formKey.currentState!.validate();

            if(isFormValid){
              state.visaEntry = state.visaEntry!.copyWith(
                entryCountry: _entryCountryController!.text.trim(),
                entryCity: _entryCityController!.text.trim().isEmpty ? null : _entryCityController!.text.trim(),
                exitCountry: _exitCountryController!.text.trim().isEmpty ? null : _exitCountryController!.text.trim(),
                exitCity: _exitCityController!.text.trim().isEmpty ? null : _exitCityController!.text.trim(),
                exitTransport: state.visaEntry!.exitTransport ?? VisaSettings.transport.first,
                hasExit: false
              );                       
              context.read<VisaEntryBloc>().add(SubmitEntry(state.visaEntry, state.visa));
            }            
  })));
}


