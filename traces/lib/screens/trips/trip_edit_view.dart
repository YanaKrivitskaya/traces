import 'package:traces/screens/trips/bloc/trip_details/tripdetails_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';

import 'model/trip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../colorsPalette.dart';
import 'package:flutter/material.dart';

class TripEditView extends StatefulWidget{
  final String tripId;

  TripEditView({this.tripId});

  @override
  _TripEditViewState createState() => _TripEditViewState();
}

class _TripEditViewState extends State<TripEditView>{
  TextEditingController _tripNameController;

  @override
  void initState() {
    super.initState();
    _tripNameController = new TextEditingController();    
  }

  @override
  void dispose() {
    _tripNameController.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(data: ThemeData(
      primaryColor: ColorsPalette.boyzone,
      primaryColorDark: Colors.red,
      accentColor: ColorsPalette.,
      scaffoldBackgroundColor: ColorsPalette.white
    ), 
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.tripId == '' ? 'New Trip' : 'Edit Trip',
          style: quicksandStyle(fontSize: 30.0)),
        backgroundColor: ColorsPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: ColorsPalette.freshBlue),
          onPressed: ()=> Navigator.pop(context)
      )),
      body: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){},
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){
            if(state is TripDetailsSuccessState){
              return _createForm(state);
            }
            return loadingWidget(ColorsPalette.boyzone);
          },
        ),
      )  
    ));
  }

  Widget _createForm(TripDetailsState state) => new Container(
    padding: EdgeInsets.all(15.0),
    child: SingleChildScrollView(
      child: Form(
        child: Column(children: [
          _tripNameInput(state)
        ],),
      ),
    ),
  );

  Widget _tripNameInput(TripDetailsState state) => new Container(
    width: MediaQuery.of(context).size.width * 0.7,
    child: Column(children: [
      Text('Where are you going?', style: quicksandStyle(fontSize: 20.0),),
      TextFormField(
        decoration: InputDecoration(
          isDense: false
        ),       
        controller: _tripNameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
            /*if (int.tryParse(value) == null) return 'Should be a number';*/
          return value.isEmpty ? 'Required field' : null;
        },
        //keyboardType: TextInputType.number
      )
    ],));

}