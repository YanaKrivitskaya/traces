import 'package:traces/screens/trips/bloc/trip_details/tripdetails_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';
import 'package:intl/intl.dart';

import 'model/trip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../colorsPalette.dart';
import 'package:flutter/material.dart';

class StartPlanningView extends StatefulWidget{
  final String tripId;

  StartPlanningView({this.tripId});

  @override
  _StartPlanningViewState createState() => _StartPlanningViewState();
}

class _StartPlanningViewState extends State<StartPlanningView>{
  TextEditingController _tripNameController;
  Trip newTrip;

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.tripId == '' ? 'Plan a new trip' : 'Edit Trip',
          style: quicksandStyle(fontSize: 30.0)),
        backgroundColor: ColorsPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: ColorsPalette.meditSea),
          onPressed: ()=> Navigator.pop(context)
      )),
      body: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state){
          if(state is TripDetailsErrorState){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.redPigment,
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Container(width: 250,
                  child: Text(
                    state.error,
                    style: quicksandStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
                Icon(Icons.error)
                ],
                ),
              ));
          }
        },
        child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
          builder: (context, state){
            if(state is TripDetailsSuccessState){
              newTrip = state.trip;
              return _createForm(state, newTrip);
            }
            return loadingWidget(ColorsPalette.boyzone);
          },
        ),
      )  
    );
  }

  Widget _createForm(TripDetailsState state, Trip trip) => new Container(
    padding: EdgeInsets.all(15.0),
    child: SingleChildScrollView(
      child: Form(
        child: Column(children: [
          Container(    
            padding: EdgeInsets.only(top: 50.0),
            child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center,children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Where are you going?', style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold/*color: ColorsPalette.meditSea*/),),
                SizedBox(height: 10.0),
                SizedBox(width:  MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,                      
                      //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      hintText: "e.g., Hawaii, Summer trip",
                      
                    ),
                    style:  quicksandStyle(fontSize: 18.0),
                    controller: _tripNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                        /*if (int.tryParse(value) == null) return 'Should be a number';*/
                      return value.isEmpty ? 'Required field' : null;
                    },
                  ),
                ),        
                SizedBox(height: 15.0),
                Row(children: [
                  Text('Dates?', style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),
                  /*Text('(optional)', style: quicksandStyle(fontSize: 13.0)),*/
                ],),
                SizedBox(height: 10.0)
              ],)           
            ]),
            Container(width:  MediaQuery.of(context).size.width * 0.7, child:
              InkWell(      
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.date_range),
                    trip?.startDate != null 
                    ?  Text('${DateFormat.yMMMd().format(trip.startDate)}',
                        style: quicksandStyle(fontSize: 18.0))
                    : Text("Start Date", style:  quicksandStyle(fontSize: 18.0)),
                    Icon(Icons.date_range),
                    trip?.endDate != null 
                    ?  Text('${DateFormat.yMMMd().format(trip.endDate)}',
                        style: quicksandStyle(fontSize: 18.0))
                    : Text("End Date", style:  quicksandStyle(fontSize: 18.0)),
                  ],
                ),
                onTap: () => _selectValidFromDate(context, state),
              )
            ),
            SizedBox(height: 10.0),
            /*Container(width:  MediaQuery.of(context).size.width * 0.7, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
              Text('Cover photo', style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),
              Text('(optional)', style: quicksandStyle(fontSize: 13.0)),
            ],)
            ],),),  */  
            SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                child: Text("Start planning"), 
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(/*ColorsPalette.juicyYellow*/ColorsPalette.meditSea),
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
                  ),
                onPressed: (){
                  context.read<TripDetailsBloc>().add(StartPlanningSubmitted(null));
                }
              )
            ],)
            ]),
            
            )
        ],),
      ),
    ),
  );

  Future<Null> _selectValidFromDate(
    BuildContext context, TripDetailsState state) async {
    final DateTimeRange picked = await showDateRangePicker (        
        context: context,
        //initialDateRange: DatDateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      /*print(picked.start);
      print(picked.end);*/
      context.read<TripDetailsBloc>().add(DateRangeUpdated(picked.start, picked.end));
      /*state.visa.durationOfStay =
          int.parse(this._durationController.text.trim());
      context.read<VisaDetailsBloc>().add(DateFromChanged(picked));*/
    }
  }

}