import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/tripdetails/expenses/bloc/expensecreate_bloc.dart';
import 'package:traces/screens/trips/widgets/create_expense_dialog.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/style/styles.dart';
import '../../../../widgets/widgets.dart';
import '../../model/booking.model.dart';
import '../../model/trip.model.dart';
import 'bloc/bookingcreate_bloc.dart';

class BookingCreateView extends StatefulWidget{
  final Trip trip;  

  BookingCreateView({required this.trip});

  @override
  _BookingCreateViewViewState createState() => _BookingCreateViewViewState();
}

class _BookingCreateViewViewState extends State<BookingCreateView>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Booking? newBooking;

  TextEditingController? _nameController;
  TextEditingController? _locationController;
  TextEditingController? _detailsController;
  TextEditingController? _guestsQuantityController;
  TextEditingController? _reservNumberController;
  TextEditingController? _reservUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _locationController = new TextEditingController();
    _detailsController = new TextEditingController();    
    _guestsQuantityController = new TextEditingController(text: "2");    
    _reservNumberController = new TextEditingController();    
    _reservUrlController = new TextEditingController();      
  }

  @override
  void dispose() {
    _nameController!.dispose();  
    _locationController!.dispose();   
    _detailsController!.dispose();   
    _guestsQuantityController!.dispose();   
    _reservNumberController!.dispose();   
    _reservUrlController!.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCreateBloc, BookingCreateState>(
      listener: (context, state) {
        if(state is BookingCreateEdit && state.loading){
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
          if(state is BookingCreateSuccess){
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
          if(state is BookingCreateError){
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
      child: BlocBuilder<BookingCreateBloc, BookingCreateState>(
        builder: (context, state){
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Add booking',
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
                        newBooking = state.booking!.copyWith(
                          name: _nameController!.text.trim(),
                          location: _locationController!.text.trim(),
                          reservationNumber: _reservNumberController!.text.trim(),
                          reservationUrl: _reservUrlController!.text.trim(),
                          details: _detailsController!.text.trim(),                        
                          guestsQuantity: int.parse(_guestsQuantityController!.text.trim())
                        );                                    
                        context.read<BookingCreateBloc>().add(BookingSubmitted(newBooking, state.booking!.expense, widget.trip.id!));
                    }},
                    icon: Icon(Icons.check, color: ColorsPalette.juicyOrange))
                ],
              ),
              body: state.booking != null ? Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 40.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: _bookingDetailsForm(state),
                  ),
                ),
              ) : loadingWidget(ColorsPalette.juicyOrange),
            );
        }
      ),
    );
  }

  Widget _bookingDetailsForm(BookingCreateState state) => 
    new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Location', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Lisboa, Portugal"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _locationController
      ),
      SizedBox(height: 10.0),
      Text('Name', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Moscavide 2E"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {                        
          return value!.isEmpty ? 'Required field' : null;
        },
      ),
      SizedBox(height: 10.0),
      SizedBox(
        width:  MediaQuery.of(context).size.width * 0.9,
        child:
        InkWell(      
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
                Icon(Icons.date_range),
              state.booking?.entryDate != null 
                ?  Text('${DateFormat.yMMMd().format(state.booking!.entryDate!)}', style: quicksandStyle(fontSize: 18.0))
                : Text("Entry Date", style:  quicksandStyle(fontSize: 18.0)),
              ],),
              SizedBox(height: 10.0),
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
                 Icon(Icons.date_range),
              state.booking?.exitDate != null 
                ?  Text('${DateFormat.yMMMd().format(state.booking!.exitDate!)}', style: quicksandStyle(fontSize: 18.0))
                : Text("Exit Date", style:  quicksandStyle(fontSize: 18.0)),
              ],)             
            ],
           ),
           Column(children: [
             Container(
              width:  MediaQuery.of(context).size.width * 0.45,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.schedule),
                SizedBox(width: 20.0),
                InkWell(
                  child: state.booking!.entryDate != null 
                    ? Text('${DateFormat.jm().format(state.booking!.entryDate!)}', style: quicksandStyle(fontSize: 18.0)) 
                    : Text('Time', style: quicksandStyle(fontSize: 18.0)),
                  onTap: () => _selectCheckInTime(context, state, widget.trip),
                )],),
            ),
            SizedBox(height: 10.0),
            Container(
              width:  MediaQuery.of(context).size.width * 0.45,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.schedule),
                SizedBox(width: 20.0),
                InkWell(
                  child: state.booking!.exitDate != null 
                    ? Text('${DateFormat.jm().format(state.booking!.exitDate!)}', style: quicksandStyle(fontSize: 18.0)) 
                    : Text('Time', style: quicksandStyle(fontSize: 18.0)),
                  onTap: () => _selectCheckOutTime(context, state, widget.trip),
                )],),
            )
           ],)
          ],),
          onTap: () => _selectDates(context, state, widget.trip),
        )
      ),
      SizedBox(height: 10.0),      
      Text('Guests #', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., 2"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _guestsQuantityController
      ),
      SizedBox(height: 10.0),
      _reservationdetails(state),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        state.booking!.expense == null ?
        ElevatedButton(
          child: Text("Add expense"), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
              backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyOrange),
              foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
            ),
            onPressed: () {
              Expense expense; 
              String category = 'Booking';
              if(state.booking!.expense != null){
                expense = state.booking!.expense!;
              }else{                
                String description = 'Booking ${_nameController!.text.trim()}';
                if(_locationController!.text.length > 0){
                  description += ', ${_locationController!.text.trim()}';
                }
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
                          context.read<BookingCreateBloc>().add(ExpenseUpdated(val));                
                        }
                      }),
                    )
                  );}
        ) : _expenseDetails(state)
      ])
    ]);   

  Future<Null> _selectDates(
    BuildContext context, BookingCreateState state, Trip trip) async {
    FocusScope.of(context).unfocus();
    final DateTimeRange? picked = await showDateRangePicker (   
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,        
      firstDate: trip.startDate ?? DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),
      helpText: 'Booking dates'
      );
    if (picked != null) {
      var checkInTime = TimeOfDay.fromDateTime(state.booking!.entryDate ?? DateTime.now());
      var checkOutTime = TimeOfDay.fromDateTime(state.booking!.exitDate ?? DateTime.now());
      var checkInDate = new DateTime.utc(picked.start.year, picked.start.month, picked.start.day, checkInTime.hour, checkInTime.minute);
      var checkOutDate = new DateTime.utc(picked.end.year, picked.end.month, picked.end.day, checkOutTime.hour, checkOutTime.minute);
      context.read<BookingCreateBloc>().add(DateRangeUpdated(checkInDate, checkOutDate));      
    }
  }

  Future<Null> _selectCheckInTime(BuildContext context, BookingCreateState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.booking!.entryDate ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.booking!.entryDate != null && state.booking!.exitDate != null){      
        var date = state.booking!.entryDate!;
        var checkInDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<BookingCreateBloc>().add(DateRangeUpdated(checkInDate, state.booking!.exitDate!));    
      }      
    }
  }

  Future<Null> _selectCheckOutTime(BuildContext context, BookingCreateState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.booking!.entryDate ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.booking!.entryDate != null && state.booking!.exitDate != null){      
        var date = state.booking!.exitDate!;
        var checkOutDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<BookingCreateBloc>().add(DateRangeUpdated(state.booking!.entryDate!, checkOutDate));    
      }      
    }
  }

    Widget _reservationdetails(BookingCreateState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Reservation #', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., 125-AB-14"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _reservNumberController
      ),
      SizedBox(height: 10.0),
      Text('Reservation Url', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., www.traces.com/booking/123"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _reservUrlController
      ),
      SizedBox(height: 10.0),
      Text('Details', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., check-in time"                      
        ),
        minLines: 5,
        maxLines: 10,
        style:  quicksandStyle(fontSize: 18.0),
        controller: _detailsController
      )
    ]
  ); 

  Widget _expenseDetails(BookingCreateState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Expense', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text('${state.booking!.expense!.amount} ${state.booking!.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
        IconButton(onPressed: (){
          showDialog(                
            barrierDismissible: false, context: context, builder: (_) =>
              BlocProvider<ExpenseCreateBloc>(
                create: (context) => ExpenseCreateBloc()..add(AddExpenseMode(state.booking!.expense!.category!.name, state.booking!.expense!)),
                  child: CreateExpenseDialog(trip: widget.trip, callback: (val) async {
                    if(val != null){
                      context.read<BookingCreateBloc>().add(ExpenseUpdated(val));
                    }
                  }),
              )
          );
        }, icon: Icon(Icons.edit, color: ColorsPalette.juicyOrange)),
        IconButton(onPressed: (){
          context.read<BookingCreateBloc>().add(ExpenseUpdated(null));
        }, 
        icon: Icon(Icons.close, color: ColorsPalette.black))
      ],),      
    ]
  ); 
}