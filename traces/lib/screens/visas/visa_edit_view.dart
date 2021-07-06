
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../utils/misc/state_types.dart';
import '../profile/model/group_user_model.dart';
import 'bloc/visa_details/visa_details_bloc.dart';
import 'model/visa_settings.model.dart';

class VisaEditView extends StatefulWidget {
  final int? visaId;

  VisaEditView({Key? key, this.visaId}) : super(key: key);

  @override
  _VisaEditViewState createState() => _VisaEditViewState();
}

class _VisaEditViewState extends State<VisaEditView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _countryController;
  TextEditingController? _durationController;  

  @override
  void initState() {
    super.initState();
    _countryController = new TextEditingController();
    _durationController = new TextEditingController();
  }

  @override
  void dispose() {
    _countryController!.dispose();
    _durationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(widget.visaId == 0 ? 'New Visa' : 'Edit Visa',
              style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorsPalette.lynxWhite),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: BlocListener<VisaDetailsBloc, VisaDetailsState>(
          listener: (context, state) {
        if (state.status == StateStatus.Error) {
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
                        state.errorMessage!,
                        style: GoogleFonts.quicksand(
                            textStyle:
                                TextStyle(color: ColorsPalette.lynxWhite)),
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
        if (state.mode == StateMode.Edit) {
          if (widget.visaId != 0) {
            _countryController!.text = state.visa!.country ?? '';
            _durationController!.text = state.visa!.durationOfStay != null ? state.visa!.durationOfStay.toString() : '';
          }
        }
        if (state.status == StateStatus.Loading &&
            state.mode == StateMode.Edit) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: ColorsPalette.algalFuel,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorsPalette.lynxWhite),
                      ),
                      height: 30.0,
                      width: 30.0,
                    ),
                  ],
                ),
              ),
            );
        }
        if (state.status == StateStatus.Success) {
          ScaffoldMessenger.of(context)
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
                        widget.visaId == ''
                            ? "Visa created successfully"
                            : "Visa updated successfully",
                        style: GoogleFonts.quicksand(
                            textStyle:
                                TextStyle(color: ColorsPalette.lynxWhite)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.info, color: ColorsPalette.lynxWhite),
                  ],
                ),
              ),
            );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.popAndPushNamed(context, visaDetailsRoute,
                arguments: state.visa!.id);
          });
        }        

      }, child: BlocBuilder<VisaDetailsBloc, VisaDetailsState>(
              builder: (context, state) {
        if (state.status == StateStatus.Loading &&
            state.mode == StateMode.View) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      ColorsPalette.algalFuel)));
        }
        if (state.mode == StateMode.Edit ||
            state.status == StateStatus.Success ||
            state.status == StateStatus.Error) {
          return Container(
              padding: EdgeInsets.all(5.0), child: _editForm(state));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      })),
      backgroundColor: Colors.white,
    );
  }

  Widget _editForm(VisaDetailsState state) => new Container(
      color: ColorsPalette.white,
      padding: EdgeInsets.all(15.0),
      //height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
          child: Form(
        key: this._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Start date",
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsPalette.mazarineBlue),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "End date",
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsPalette.mazarineBlue),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('${DateFormat.yMMMd().format(state.visa!.startDate!)}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30.0),
                    Text('${DateFormat.yMMMd().format(state.visa!.endDate!)}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.calendarAlt,
                        color: ColorsPalette.mazarineBlue,
                      ),
                      onPressed: () => _selectValidFromDate(context, state),
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.calendarAlt,
                        color: ColorsPalette.mazarineBlue,
                      ),
                      onPressed: () => _selectValidToDate(context, state),
                    )
                  ],
                ),
              ],
            ),
            Divider(color: ColorsPalette.algalFuel),
            _submitButton(state)
          ],
        ),
      )));

  Widget _submitButton(VisaDetailsState state) => new Center(
      child: ElevatedButton(          
          child: Text(widget.visaId == '' ? 'Create visa' : 'Save'),          
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
            backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.algalFuel),
            foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.lynxWhite)
          ),
          onPressed: () {
            var isFormValid = _formKey.currentState!.validate();

            state.visa = state.visa!.copyWith(
              country: _countryController!.text.trim(),
              durationOfStay: int.parse(this._durationController!.text.trim())
            );           

            context.read<VisaDetailsBloc>().add(VisaSubmitted(state.visa, isFormValid));
          }));

  Widget _ownerSelector(VisaDetailsState state) =>
      new DropdownButtonFormField<GroupUser>(
          value: state.visa!.user,
          isExpanded: true,
          decoration: InputDecoration(
              labelText: "Visa owner",
              labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
          items: state.familyGroup!.users.map((GroupUser member) {
            return new DropdownMenuItem<GroupUser>(
              value: member,
              child: new Text(member.name),
            );
          }).toList(),
          onChanged: (GroupUser? value) {
            state.visa = state.visa!.copyWith(user: value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value == null ? 'Required field' : null;
          });

  Widget _countrySelector(VisaDetailsState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._countryController,
        decoration: InputDecoration(
            labelText: 'Country of issue',
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      ),
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          /*var filteredCountries = state.userSettings!.countries!
              .where((c) => c.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
          if (filteredCountries.length > 0) {
            return filteredCountries;
          }  */    
          return [];    
        }
        return [];
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
        this._countryController!.text = suggestion;
        FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });

  Widget _durationSelector(VisaDetailsState state) => new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Duration of stay',
          labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
      controller: _durationController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (int.tryParse(value!) == null) return 'Should be a number';
        return value.isEmpty ? 'Required field' : null;
      },
      keyboardType: TextInputType.number);

  Widget _typeSelector(VisaDetailsState state) =>
      new DropdownButtonFormField<String>(
        value: state.visa!.type,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Type",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items: VisaSettings.visaTypes.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          state.visa = state.visa!.copyWith(type: value);
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Widget _entriesNumberSelector(VisaDetailsState state) =>
      new DropdownButtonFormField<String>(
        value: state.visa!.entriesType,
        isExpanded: true,
        decoration: InputDecoration(
            labelText: "Entries",
            labelStyle: TextStyle(color: ColorsPalette.mazarineBlue)),
        items: VisaSettings.entries.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          state.visa = state.visa!.copyWith(entriesType: value);        
          FocusScope.of(context).unfocus();          
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Future<Null> _selectValidFromDate(
      BuildContext context, VisaDetailsState state) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child!,
          );
        },
        context: context,
        initialDate: state.visa!.startDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != state.visa!.startDate) {     
      context.read<VisaDetailsBloc>().add(DateFromChanged(picked));
    }
  }

  Future<Null> _selectValidToDate(
      BuildContext context, VisaDetailsState state) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(primarySwatch: ColorsPalette.matVisaCalendarColor),
            child: child!,
          );
        },
        context: context,
        initialDate: state.visa!.startDate!.add(new Duration(days: 1)),
        firstDate: state.visa!.startDate!.add(new Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != state.visa!.endDate) {      
      context.read<VisaDetailsBloc>().add(DateToChanged(picked));
    }
  }
}
