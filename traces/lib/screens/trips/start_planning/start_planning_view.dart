import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../utils/style/styles.dart';
import '../../../widgets/widgets.dart';
import '../model/trip.model.dart';
import 'bloc/startplanning_bloc.dart';
import 'package:sizer/sizer.dart';

class StartPlanningView extends StatefulWidget{  
  StartPlanningView();

  @override
  _StartPlanningViewState createState() => _StartPlanningViewState();
}

class _StartPlanningViewState extends State<StartPlanningView>{
  TextEditingController? _tripNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Trip? newTrip;
  // declare as global
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tripNameController = new TextEditingController();    
  }

  @override
  void dispose() {
    _tripNameController!.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Width: ${MediaQuery.of(context).size.width}");
    print("Height: ${MediaQuery.of(context).size.height}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Trip info',
          style: quicksandStyle(fontSize: headerFontSize)),
        backgroundColor: ColorsPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: ColorsPalette.black,),
          onPressed: ()=> Navigator.pop(context)
      )),
      body: BlocListener<StartPlanningBloc, StartPlanningState>(
        listener: (context, state){
          if(state is StartPlanningSuccessState && state.loading){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyYellow,
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
            ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyYellow,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                    Icon(Icons.check, color: ColorsPalette.lynxWhite,)
                ],
                ),
              ));
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.popAndPushNamed(context, tripDetailsRoute,
                    arguments: state.trip!.id);
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
              return loadingWidget(ColorsPalette.juicyYellow);
            }
            newTrip = state.trip;            
            return _createForm(state, newTrip);
            //return loadingWidget(ColorsPalette.boyzone);
          },
        ),
      )  
    );
  }

  Widget _createForm(StartPlanningState state, Trip? trip) => new Container(
    padding: EdgeInsets.all(viewPadding),
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: [
          Container(    
            padding: EdgeInsets.only(top: formTopPadding),
            child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center,children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Trip name', style: quicksandStyle(fontSize: accentFontSize, weight: FontWeight.bold/*color: ColorsPalette.meditSea*/),),
                SizedBox(height: sizerHeightsm),
                SizedBox(width: formWidth70,
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,                      
                      hintText: "e.g., Hawaii, Summer trip"                      
                    ),
                    style:  quicksandStyle(fontSize: fontSize),
                    controller: _tripNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {                        
                      return value!.isEmpty ? 'Required field' : null;
                    },
                  ),
                ),
                SizedBox(height: sizerHeightsm),
                Row(children: [
                  Text('Dates', style: quicksandStyle(fontSize: accentFontSize, weight: FontWeight.bold)),
                  /*Text('(optional)', style: quicksandStyle(fontSize: 13.0)),*/
                ],),
                SizedBox(height: sizerHeightsm),
                SizedBox(
                  width: formWidth70,
                  child:
                    InkWell(      
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.date_range),
                          trip?.startDate != null 
                          ?  Text('${DateFormat.yMMMd().format(trip!.startDate!)}',
                              style: quicksandStyle(fontSize: fontSize))
                          : Text("Start Date", style:  quicksandStyle(fontSize: fontSize)),
                          Icon(Icons.date_range),
                          trip?.endDate != null 
                          ?  Text('${DateFormat.yMMMd().format(trip!.endDate!)}',
                              style: quicksandStyle(fontSize: fontSize))
                          : Text("End Date", style:  quicksandStyle(fontSize: fontSize)),
                        ],
                      ),
                      onTap: () => _selectDates(context, state),
                    )
                )
              ],)
            ]),                    
            
            SizedBox(height: formBottomPadding),                      
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                child: Text("Let's go!", style: quicksandStyle(fontSize: fontSize, color: ColorsPalette.white)), 
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: buttonPadding)),
                    backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyYellow),
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
                  ),
                onPressed: (){
                  var isFormValid = _formKey.currentState!.validate();                 

                  if(isFormValid){
                    Trip newTrip = trip!.copyWith(name: _tripNameController!.text.trim());                                    
                    context.read<StartPlanningBloc>().add(StartPlanningSubmitted(newTrip));
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
    final DateTimeRange? picked = await showDateRangePicker (        
        context: context,        
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        helpText: 'Trip dates'
      );
    if (picked != null) {
      var startDate = DateTime.utc(picked.start.year, picked.start.month, picked.start.day);
      var endDate = DateTime.utc(picked.end.year, picked.end.month, picked.end.day);
      context.read<StartPlanningBloc>().add(DateRangeUpdated(startDate, endDate));      
    }
  }

}