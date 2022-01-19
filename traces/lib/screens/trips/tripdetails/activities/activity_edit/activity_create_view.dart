import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:traces/screens/trips/model/activity_category.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/tripdetails/activities/activity_edit/bloc/activitycreate_bloc.dart';
import 'package:traces/screens/trips/tripdetails/expenses/bloc/expensecreate_bloc.dart';
import 'package:traces/screens/trips/widgets/create_expense_dialog.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../utils/style/styles.dart';
import '../../../../../widgets/widgets.dart';
import '../../../model/activity.model.dart';
import '../../../model/trip.model.dart';

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
  TextEditingController? _locationController;
  TextEditingController? _categoryController;
  TextEditingController? _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _locationController = new TextEditingController();
    _categoryController = new TextEditingController();
    _descriptionController = new TextEditingController();
 
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _locationController!.dispose();
    _categoryController!.dispose();
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
                Navigator.pop(context, 1);
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
          if(state is ActivityCreateEdit && !state.loading && state.activity != null){
            _nameController!.text == '' ? _nameController!.text = state.activity!.name ?? '' : '';
            _locationController!.text == '' ? _locationController!.text = state.activity!.location ?? '' : '';
            _descriptionController!.text == '' ? _descriptionController!.text = state.activity!.description ?? '' : '';            
            _categoryController!.text == '' ? _categoryController!.text = state.activity!.category?.name ?? '' : '';            
          }
      },
      child: BlocBuilder<ActivityCreateBloc, ActivityCreateState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: Text('Activity',
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

                      var category = new ActivityCategory(name: _categoryController!.text.trim());
                      if(state.categories != null){
                        category = state.categories!.firstWhere((c) => c.name! == _categoryController!.text.trim(), orElse: () => category);
                      }                

                      if(isFormValid){
                        newActivity = state.activity!.copyWith(
                          name: _nameController!.text.trim(),
                          location: _locationController!.text.trim(),
                          description: _descriptionController!.text.trim(),                          
                          isPlanned: state.activity!.isPlanned ?? true,
                          isCompleted: state.activity!.isCompleted ?? true,
                          category: category,
                        );                                    
                        context.read<ActivityCreateBloc>().add(ActivitySubmitted(newActivity, state.activity!.expense, widget.trip.id!));
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
      Text('Location', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Lisboa"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _locationController
      ),
      SizedBox(height: 20.0),
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
      Text('Category', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      _categorySelector(state),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(Icons.date_range),
            SizedBox(width: 20.0),
            InkWell(
              child: state.activity!.date != null 
                ? Text('${DateFormat.yMMMd().format( state.activity!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Date', style: quicksandStyle(fontSize: 18.0)),
              onTap: () => _selectDate(context, state, widget.trip)
            )
          ]),
        ),        
        Container(
          width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(Icons.schedule),
            SizedBox(width: 20.0),
            InkWell(
              child: state.activity!.date != null 
                ? Text('${DateFormat.jm().format(state.activity!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Time', style: quicksandStyle(fontSize: 18.0)),
              onTap: () => _selectTime(context, state, widget.trip),
            )],),
        )  
        ],),
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
        state.activity!.expense == null ?
        ElevatedButton(
          child: Text("Add expense"), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
              backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyOrange),
              foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
            ),
            onPressed: (){
              Expense expense;
              String category = 'Activity';
              if(_categoryController!.text.length > 0){
                category = _categoryController!.text.trim();
              }
              
              if(state.activity!.expense != null){
                expense = state.activity!.expense!;
              }else{                
                String description = 'Activity ${_nameController!.text.trim()}';
                DateTime now = DateTime.now();
                DateTime date = new DateTime.utc(now.year, now.month, now.day);
                
                expense = new Expense(date: date, description: description);
              }
              
              showDialog(                
                  barrierDismissible: false, context: context, builder: (_) =>
                    BlocProvider<ExpenseCreateBloc>(
                      create: (context) => ExpenseCreateBloc()..add(AddExpenseMode(category, expense)),
                      child: CreateExpenseDialog(trip: widget.trip, callback: (val) async {
                        if(val != null){
                          context.read<ActivityCreateBloc>().add(ExpenseUpdated(val));                
                        }
                      }),
                    )
                  );
            }
        ) : _expenseDetails(state)
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
      var time = TimeOfDay.fromDateTime(state.activity!.date ?? DateTime.now());
      var activityDate = new DateTime.utc(picked.year, picked.month, picked.day, time.hour, time.minute);
      context.read<ActivityCreateBloc>().add(ActivityDateUpdated(activityDate));      
    }
  }

  Future<Null> _selectTime(BuildContext context, ActivityCreateState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.activity!.date ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.activity!.date != null){      
        var date = state.activity!.date!;
        var activityDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<ActivityCreateBloc>().add(ActivityDateUpdated(activityDate));    
      }
      
    }
  }

  Widget _categorySelector(ActivityCreateState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._categoryController,      
      ),
      suggestionsCallback: (pattern) {
        {
          var filteredCategories = state.categories != null ? state.categories!
              .where((c) => c.name!.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList() : [];
          if (filteredCategories.length > 0) {
            return filteredCategories;
          }   
          return [];    
        }       
      },     
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic category) {
        return ListTile(
          title: Text(category.name),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._categoryController!.text = suggestion.name;
        FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });

Widget _expenseDetails(ActivityCreateState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Expense', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text('${state.activity!.expense!.amount} ${state.activity!.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
        IconButton(onPressed: (){
          showDialog(                
            barrierDismissible: false, context: context, builder: (_) =>
              BlocProvider<ExpenseCreateBloc>(
                create: (context) => ExpenseCreateBloc()..add(AddExpenseMode(state.activity!.expense!.category!.name, state.activity!.expense!)),
                  child: CreateExpenseDialog(trip: widget.trip, callback: (val) async {
                    if(val != null){
                      context.read<ActivityCreateBloc>().add(ExpenseUpdated(val));
                    }
                  }),
              )
          );
        }, 
        icon: Icon(Icons.edit, color: ColorsPalette.juicyOrange)),
        IconButton(onPressed: (){
          context.read<ActivityCreateBloc>().add(ExpenseUpdated(null));
        }, 
        icon: Icon(Icons.close, color: ColorsPalette.black))
      ],),      
    ]
  ); 

}