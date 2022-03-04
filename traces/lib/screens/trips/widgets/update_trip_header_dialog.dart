import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class UpdateTripHeaderDialog extends StatefulWidget {

  final Trip? trip;
  final StringCallback? callback;

  const UpdateTripHeaderDialog({Key? key, this.trip, this.callback}) : super(key: key);

   @override
  _UpdateTripHeaderDialogState createState() => new _UpdateTripHeaderDialogState();
}

class _UpdateTripHeaderDialogState extends State<UpdateTripHeaderDialog>{
  TextEditingController? _tripNameController;
  TextEditingController? _tripDescriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tripNameController = new TextEditingController();
    _tripDescriptionController = new TextEditingController();
  }

  @override
  void dispose() {
    _tripNameController!.dispose();  
    _tripDescriptionController!.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripDetailsBloc, TripDetailsState>(
      listener: (context, state){
        if(state is TripDetailsUpdated){
          widget.callback!('Update');
          Navigator.pop(context);
        }        
      },
      child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
        bloc: BlocProvider.of(context),
        builder: (context, state){
          if(_tripNameController!.text.length == 0 && state.trip != null) _tripNameController!.text = state.trip!.name!;
          if(_tripDescriptionController!.text.length == 0 && state.trip!.description != null) _tripDescriptionController!.text = state.trip!.description!;
          return AlertDialog(
            title: Text("Trip details"),
            content: SingleChildScrollView(            
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  Form(
                    key: _formKey,
                    child: _tripDetailsForm(state),
                  )                  
                ],
              )
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Update', style: TextStyle(color: ColorsPalette.meditSea)),
                onPressed: () {
                  var isFormValid = _formKey.currentState!.validate();                

                  if(isFormValid){
                    Trip trip = state.trip!.copyWith(                                               
                      name: _tripNameController!.text.trim(),
                      description: _tripDescriptionController!.text.trim(),
                    );
                    context.read<TripDetailsBloc>().add(UpdateTripClicked(trip));
                    
                  }                  
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: ColorsPalette.meditSea),),
                onPressed: () {
                  widget.callback!('Cancel');
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _tripDetailsForm(TripDetailsState state) => 
    new Column(crossAxisAlignment:  CrossAxisAlignment.start, children: [
      Text('Name', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Summer vacation"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _tripNameController
      ),
      SizedBox(height: 20.0,),
      Text('Description', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Trip over Tejo river"                      
        ),
        minLines: 5,
        maxLines: 10,
        style:  quicksandStyle(fontSize: 18.0),
        controller: _tripDescriptionController
      ),
      SizedBox(height: 20.0),
      Row(children: [
        Text('Dates', style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),                  
      ],),
      SizedBox(height: 10.0),
      SizedBox(
        width:  MediaQuery.of(context).size.width * 0.7,
        child:
          InkWell(      
            child: Column(children: [
              Row(children: [
                Icon(Icons.date_range),
                  state.trip?.startDate != null 
                  ?  Text('${DateFormat.yMMMd().format(state.trip!.startDate!)}', style: quicksandStyle(fontSize: 18.0))
                  : Text("Start Date", style:  quicksandStyle(fontSize: 18.0))
              ],),
              Row(children: [
                Icon(Icons.date_range),
                  state.trip?.endDate != null 
                  ?  Text('${DateFormat.yMMMd().format(state.trip!.endDate!)}', style: quicksandStyle(fontSize: 18.0))
                  : Text("End Date", style:  quicksandStyle(fontSize: 18.0))
              ],)
            ],),
            onTap: () => _selectDates(context, state),
          )
      )
    ]);

    Future<Null> _selectDates(
    BuildContext context, TripDetailsState state) async {
    FocusScope.of(context).unfocus();
    final DateTimeRange? picked = await showDateRangePicker (        
        context: context,        
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        helpText: 'Trip dates'
      );
    if (picked != null) {      
      context.read<TripDetailsBloc>().add(DateRangeUpdated(picked.start, picked.end));      
    }
  }

}