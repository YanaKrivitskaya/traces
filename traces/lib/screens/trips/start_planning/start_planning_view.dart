import 'package:traces/constants/route_constants.dart';

import 'bloc/startplanning_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';
import 'package:intl/intl.dart';

import '../model/trip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/color_constants.dart';
import 'package:flutter/material.dart';

class StartPlanningView extends StatefulWidget{  
  StartPlanningView();

  @override
  _StartPlanningViewState createState() => _StartPlanningViewState();
}

class _StartPlanningViewState extends State<StartPlanningView>{
  TextEditingController _tripNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: Text('Plan a new trip',
          style: quicksandStyle(fontSize: 30.0)),
        backgroundColor: ColorsPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: ColorsPalette.meditSea),
          onPressed: ()=> Navigator.pop(context)
      )),
      body: BlocListener<StartPlanningBloc, StartPlanningState>(
        listener: (context, state){
          if(state is StartPlanningSuccessState && state.loading){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.meditSea,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorsPalette.lynxWhite),
                      ),
                      height: 30.0,
                      width: 30.0,
                    ),
                ],
                ),
              ));
          }
          if(state is StartPlanningCreatedState){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.meditSea,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                    Icon(Icons.check, color: ColorsPalette.lynxWhite,)
                ],
                ),
              ));
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.popAndPushNamed(context, tripDetailsRoute,
                    arguments: state.trip.id);
              });
          }
          if(state is StartPlanningErrorState){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.redPigment,
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Container(width: 250,
                  child: Text(
                    state.error,
                    style: quicksandStyle(color: ColorsPalette.lynxWhite),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
                Icon(Icons.error, color: ColorsPalette.lynxWhite)
                ],
                ),
              ));
          }
        },
        child: BlocBuilder<StartPlanningBloc, StartPlanningState>(
          builder: (context, state){
            if (state is StartPlanningInitial){
              return loadingWidget(ColorsPalette.boyzone);
            }
            newTrip = state.trip;            
            return _createForm(state, newTrip);
            //return loadingWidget(ColorsPalette.boyzone);
          },
        ),
      )  
    );
  }

  Widget _createForm(StartPlanningState state, Trip trip) => new Container(
    padding: EdgeInsets.all(15.0),
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
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
                      hintText: "e.g., Hawaii, Summer trip"                      
                    ),
                    style:  quicksandStyle(fontSize: 18.0),
                    controller: _tripNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {                        
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
                onTap: () => _selectDates(context, state),
              )
            ),
            SizedBox(height: 30.0),           
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                child: Text("Start planning"), 
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.meditSea),
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
                  ),
                onPressed: (){
                  var isFormValid = _formKey.currentState.validate();                 

                  if(isFormValid){
                    print(trip.toString());
                    trip.name = _tripNameController.text.trim();                    
                    context.read<StartPlanningBloc>().add(StartPlanningSubmitted(trip));
                  }                  
                }
              )
            ],)
            ]),
            
            )
        ],),
      ),
    ),
  );

  Future<Null> _selectDates(
    BuildContext context, StartPlanningState state) async {
    FocusScope.of(context).unfocus();
    final DateTimeRange picked = await showDateRangePicker (        
        context: context,        
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        helpText: 'Trip dates'
      );
    if (picked != null) {      
      context.read<StartPlanningBloc>().add(DateRangeUpdated(picked.start, picked.end));      
    }
  }

}