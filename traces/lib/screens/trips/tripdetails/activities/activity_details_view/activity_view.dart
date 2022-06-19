import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/activities/activity_details_view/bloc/activityview_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class ActivityView extends StatefulWidget{
  final Trip trip;

  ActivityView({required this.trip});

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>{
  Activity? activity;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityViewBloc, ActivityViewState>(
      listener: (context, state){
        if(state.activity != null) activity = state.activity!;

        if(state is ActivityViewError){
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
                    maxLines: 5                    
                  ),
                ),
                Icon(Icons.error, color: ColorsPalette.lynxWhite)
                ],
                ),
                duration: Duration(seconds: 10),
              ));
          }
      },
      child: BlocBuilder<ActivityViewBloc, ActivityViewState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Activity details',
                style: quicksandStyle(fontSize: 25.0)),
              backgroundColor: ColorsPalette.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color:ColorsPalette.black),
                onPressed: ()=> Navigator.pop(context)
              ),
              actions: activity != null ? [
                IconButton(onPressed: (){
                  ActivityEditArguments args = new ActivityEditArguments(trip: widget.trip, activity: activity!);
                  Navigator.pushNamed(context, activityEditRoute, arguments: args).then((value){
                    value != null ? context.read<ActivityViewBloc>().add(GetActivityDetails(activity!.id!)) : '';
                  });
                }, icon: Icon(Icons.edit_outlined, color:ColorsPalette.black)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline, color:ColorsPalette.black))
              ] : [],
            ),
            
            body: activity != null ? Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(child: _activityDetails(activity!)),
            ) : loadingWidget(ColorsPalette.juicyYellow),
          );
        },
      ),
    );
  }

  Widget _activityDetails(Activity activity){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(color: ColorsPalette.juicyOrange,),
      Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('${DateFormat.yMMMd().format(activity.date!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],)  
      ),
      Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${DateFormat.Hm().format(activity.date!)}', style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),
          
        ],),
        Text('${activity.location ?? ''}', style: quicksandStyle(fontSize: 18.0)),
        Text(activity.name ?? '', style: quicksandStyle(fontSize: 18.0)),
        SelectableText(activity.description ?? '', style: quicksandStyle(fontSize: 18.0)),      
        Row(children: [
          Text('Planned', style: quicksandStyle(fontSize: 18.0)),
          activity.isPlanned! ? Icon(Icons.check, color: ColorsPalette.juicyGreen,) : Icon(Icons.close, color: ColorsPalette.christmasRed,)
        ],),
        Row(children: [
          Text('Completed', style: quicksandStyle(fontSize: 18.0)),
          activity.isCompleted! ? Icon(Icons.check, color: ColorsPalette.juicyGreen,) : Icon(Icons.close, color: ColorsPalette.christmasRed,)
        ],)
      ],)),
      Divider(color: ColorsPalette.juicyOrange),
      activity.expense != null ?
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Expense:', style: quicksandStyle(fontSize: 20.0)),
        SizedBox(height: 5.0),
        Row(children: [
            Text('${activity.expense!.amount} ${activity.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
            SizedBox(width: 20.0),
            Chip(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              backgroundColor: activity.expense!.isPaid! ? ColorsPalette.natureGreenLight : ColorsPalette.juicyOrangeLight,
              label: Text(activity.expense!.isPaid! ? 'Paid' : 'Planned', style: TextStyle(color: activity.expense!.isPaid! ? ColorsPalette.juicyGreen : ColorsPalette.juicyOrangeDark)),
            ),
          ])        
      ],) : Container()
    ],

    );    
  }
}