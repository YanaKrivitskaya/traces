import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/style/styles.dart';
import '../../../../widgets/widgets.dart';
import '../../model/activity.model.dart';
import '../../model/trip.model.dart';
import 'bloc/activitycreate_bloc.dart';

class ActivityCreateView extends StatefulWidget{
  final Trip trip;  

  ActivityCreateView({required this.trip});

  @override
  _ActivityCreateViewViewState createState() => _ActivityCreateViewViewState();
}

class _ActivityCreateViewViewState extends State<ActivityCreateView>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Activity? newActivity;

  TextEditingController? _nameController;
  TextEditingController? _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _descriptionController = new TextEditingController();
 
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _descriptionController!.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCreateBloc, ActivityCreateState>(
      listener: (context, state) {
        if(state is ActivityCreateEdit && state.loading){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyOrange,
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
          if(state is ActivityCreateSuccess){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyOrange,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                    Icon(Icons.check, color: ColorsPalette.lynxWhite,)
                ],
                ),
              ));
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
          }
          if(state is ActivityCreateError){
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
      child: BlocBuilder<ActivityCreateBloc, ActivityCreateState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: Text('Add activity',
                  style: quicksandStyle(fontSize: 30.0)),
                backgroundColor: ColorsPalette.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: ()=> Navigator.pop(context)
                ),
                actions: [
                  IconButton(
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      var isFormValid = _formKey.currentState!.validate();                 

                      if(isFormValid){
                        newActivity = state.activity!.copyWith(
                          name: _nameController!.text.trim(),                        
                          description: _descriptionController!.text.trim(),                          
                          isPlanned: state.activity!.isPlanned ?? true,
                          isCompleted: state.activity!.isCompleted ?? true
                        );                                    
                        context.read<ActivityCreateBloc>().add(ActivitySubmitted(newActivity, null, widget.trip.id!));
                    }},
                    icon: Icon(Icons.check, color: ColorsPalette.juicyOrange))
                ],
            ),
            body: state.activity != null ? Container(
              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 40.0),
              child:SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: _activityDetailsForm(state),
                  ),
                )
            ) : loadingWidget(ColorsPalette.juicyOrange),
          );
        }
      ),
    );
  }

  Widget _activityDetailsForm(ActivityCreateState state) => new Column(
    crossAxisAlignment:  CrossAxisAlignment.start,
    children: [
      Text('Name', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Boat trip"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {                        
          return value!.isEmpty ? 'Required field' : null;
        },
      ),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(Icons.date_range),
        SizedBox(width: 20.0),
        InkWell(
          child: state.activity!.date != null 
            ? Text('${DateFormat.yMMMd().format( state.activity!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
            : Text('Date', style: quicksandStyle(fontSize: 18.0)),
          onTap: () => _selectDate(context, state, widget.trip)
        )],),
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
        controller: _descriptionController
      ),
      SizedBox(height: 10.0,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child:  Row(children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: Checkbox(
                  value: state.activity!.isPlanned ?? true,
                  onChanged: (value) {
                    context.read<ActivityCreateBloc>().add(PlannedUpdated(value!));      
                  },
                ),
            ),
            SizedBox(width: 15.0,),
            Text('Planned', style: quicksandStyle(fontSize: 18.0)),
            ],),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: Row(children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: Checkbox(
                  value: state.activity!.isCompleted ?? true,
                  onChanged: (value) {
                    context.read<ActivityCreateBloc>().add(CompletedUpdated(value!));      
                  },
                ),
            ),
            SizedBox(width: 15.0,),
            Text('Completed', style: quicksandStyle(fontSize: 18.0)),
            ],)  ,
          )                  
        ],
      ),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        ElevatedButton(
          child: Text("Add expense"), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
              backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyOrange),
              foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
            ),
            onPressed: (){ }
        )
      ])
    ],
  );

  Future<Null> _selectDate(
    BuildContext context, ActivityCreateState state, Trip trip) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker (
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,   
      initialDate: state.activity!.date ?? trip.startDate ?? DateTime.now(),      
      firstDate: trip.startDate ?? DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),        
    );
    if (picked != null) {
      context.read<ActivityCreateBloc>().add(DateUpdated(picked));      
    }
  }

}