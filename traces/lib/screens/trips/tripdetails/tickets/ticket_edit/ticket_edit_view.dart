import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/trips/tripdetails/expenses/expense_edit/bloc/expensecreate_bloc.dart';

import '../../../../../constants/color_constants.dart';
import '../../../../../utils/style/styles.dart';
import '../../../../../widgets/widgets.dart';
import '../../../model/expense.model.dart';
import '../../../model/ticket.model.dart';
import '../../../model/trip.model.dart';
import '../../../model/trip_settings.model.dart';
import '../../../widgets/create_expense_dialog.dart';
import 'bloc/ticketedit_bloc.dart';

class TicketEditView extends StatefulWidget{
  final Trip trip;  

  TicketEditView({required this.trip});

  @override
  _TicketEditViewState createState() => _TicketEditViewState();
}

class _TicketEditViewState extends State<TicketEditView>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Ticket? newTicket;

  TextEditingController? _depLocationController;
  TextEditingController? _arrivalLocationController;
  TextEditingController? _carrierController;
  TextEditingController? _carrierNumberController;
  TextEditingController? _quantityController;
  TextEditingController? _seatsController;
  TextEditingController? _detailsController;
  TextEditingController? _reservNumberController;
  TextEditingController? _reservUrlController;

  @override
  void initState() {
    super.initState();
    _depLocationController = new TextEditingController();
    _arrivalLocationController = new TextEditingController();    
    _carrierController = new TextEditingController();    
    _carrierNumberController = new TextEditingController();    
    _quantityController = new TextEditingController(text: "1");    
    _seatsController = new TextEditingController(); 
    _detailsController = new TextEditingController();   
    _reservNumberController = new TextEditingController();    
    _reservUrlController = new TextEditingController();    
  }

  @override
  void dispose() {
    _depLocationController!.dispose();   
    _arrivalLocationController!.dispose();   
    _carrierController!.dispose();   
    _carrierNumberController!.dispose();   
    _quantityController!.dispose(); 
    _seatsController!.dispose();
    _detailsController!.dispose();
    _reservNumberController!.dispose();   
    _reservUrlController!.dispose();   

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketEditBloc, TicketEditState>(
      listener:(context, state){
        if(state is TicketCreateEdit && state.loading){
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
          if(state is TicketCreateEdit && !state.loading && state.ticket != null){
            _depLocationController!.text == '' ? _depLocationController!.text = state.ticket!.departureLocation ?? '' : '';
            _arrivalLocationController!.text == '' ? _arrivalLocationController!.text = state.ticket!.arrivalLocation ?? '' : '';
            _carrierController!.text == '' ? _carrierController!.text = state.ticket!.carrier ?? '' : '';
            _carrierNumberController!.text == '' ? _carrierNumberController!.text = state.ticket!.carrierNumber ?? '' : '';
            _quantityController!.text == '' ? _quantityController!.text = state.ticket!.quantity?.toString() ?? '' : '';
            _seatsController!.text == '' ? _seatsController!.text = state.ticket!.seats ?? '' : '';
            _detailsController!.text == '' ? _detailsController!.text = state.ticket!.details ?? '' : '';
            _reservNumberController!.text == '' ? _reservNumberController!.text = state.ticket!.reservationNumber ?? '' : '';
            _reservUrlController!.text == '' ? _reservUrlController!.text = state.ticket!.reservationUrl ?? '' : '';
            _quantityController!.text == '' ? _quantityController!.text = state.ticket!.quantity?.toString() ?? '1' : '';
          }
          if(state is TicketCreateSuccess){
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
          if(state is TicketCreateError){
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
      child: BlocBuilder<TicketEditBloc, TicketEditState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Ticket',
                style: quicksandStyle(fontSize: 30.0)),
              backgroundColor: ColorsPalette.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: ColorsPalette.black,),
                onPressed: ()=> Navigator.pop(context)
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    var isFormValid = _formKey.currentState!.validate();                 

                    if(isFormValid){
                      newTicket = createTicketModel(state);                                    
                      context.read<TicketEditBloc>().add(TicketSubmitted(newTicket, state.ticket!.expense, widget.trip.id!, null));
                    } 
                  }, 
                  icon:  Icon(Icons.check, color: ColorsPalette.juicyOrange,))
              ],
            ),
            body: state.ticket != null ? Container(
              padding: EdgeInsets.only(top: borderPadding, left: borderPadding, right: borderPadding, bottom: formBottomPadding),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: _ticketDetailsForm(state),
                ),
              ),
            ) : loadingWidget(ColorsPalette.juicyYellow),
          );
        }
      ),
    );
  }

  Widget _ticketDetailsForm(TicketEditState state) => 
    new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Type', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),                    
      _typeSelector(state),
      SizedBox(height: 10.0),
      _departureDetails(state),
      SizedBox(height: 10.0),
      _arrivalDetails(state),
      SizedBox(height: 10.0),                    
      _carrierDetails(state),
      SizedBox(height: 10.0),
      _seatsDetails(state),
      SizedBox(height: 10.0),
      _reservationdetails(state),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        state.ticket!.expense == null ?
        ElevatedButton(
          child: Text("Add expense"), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),
              backgroundColor: MaterialStateProperty.all<Color>(ColorsPalette.juicyOrange),
              foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.white)
            ),
            onPressed: (){
              Expense expense;
              String category = 'Tickets';
                            
              if(state.ticket!.expense != null){
                expense = state.ticket!.expense!;
              }else{                
                String description = '${state.ticket!.type ?? TripSettings.ticketType.first} ticket ${_depLocationController!.text.trim()} - ${_arrivalLocationController!.text.trim()}';
                DateTime now = DateTime.now();
                DateTime tripEnd = widget.trip.endDate ?? now;
                DateTime date = tripEnd.isAfter(now) 
                  ? new DateTime.utc(now.year, now.month, now.day) 
                  : new DateTime.utc(tripEnd.year, tripEnd.month, tripEnd.day);
                expense = new Expense(date: date, description: description);
              }
              
              showDialog(                
                  barrierDismissible: false, context: context, builder: (_) =>
                    BlocProvider<ExpenseCreateBloc>(
                      create: (context) =>ExpenseCreateBloc()..add(AddExpenseMode(category, expense)),
                      child: CreateExpenseDialog(trip: widget.trip, submitExpense: false, callback: (val) async {
                        if(val != null){
                          context.read<TicketEditBloc>().add(ExpenseUpdated(val));                
                        }
                      }),
                    )
                  );
            }
        ) : _expenseDetails(state)
      ])
    ]);                

  Widget _typeSelector(TicketEditState state) =>
      new DropdownButtonFormField<String>(
        value: state.ticket!.type ?? TripSettings.ticketType.first,
        isExpanded: true,        
        items:
            TripSettings.ticketType.map((String value) {
          return new DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  transportIcon(value, ColorsPalette.natureGreen),
                  SizedBox(
                    width: 15.0,
                  ),
                  new Text(value),
                ],
              ));
        }).toList(),
        onChanged: (String? value) {
          state.ticket = state.ticket!.copyWith(type: value);
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Widget _departureDetails(TicketEditState state) => new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Departure', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),                   
    TextFormField(
      decoration: InputDecoration(
        isDense: true,                      
        hintText: "e.g., Lisboa"                      
    ),
    style:  quicksandStyle(fontSize: 18.0),
    controller: _depLocationController,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) {                        
      return value!.isEmpty ? 'Required field' : null;
    },
    ),
    SizedBox(height: 20.0),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        width:  MediaQuery.of(context).size.width * 0.45,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(Icons.date_range),
          SizedBox(width: 20.0),
          InkWell(
            child: state.ticket!.departureDatetime != null 
              ? Text('${DateFormat.yMMMd().format(state.ticket!.departureDatetime!)}', style: quicksandStyle(fontSize: 18.0)) 
              : Text('Date', style: quicksandStyle(fontSize: 18.0)),
            onTap: () => _selectDepDate(context, state, widget.trip)
          )],),
      ),
      Container(
        width:  MediaQuery.of(context).size.width * 0.45,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(Icons.schedule),
          SizedBox(width: 20.0),
          InkWell(
            child: state.ticket!.departureDatetime != null 
              ? Text('${DateFormat.Hm().format(state.ticket!.departureDatetime!)}', style: quicksandStyle(fontSize: 18.0)) 
              : Text('Time', style: quicksandStyle(fontSize: 18.0)),
            onTap: () => _selectDepTime(context, state, widget.trip),
          )],),
      )                      
    ])
  ]);  

  Widget _arrivalDetails(TicketEditState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Arrival', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),                   
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Porto"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _arrivalLocationController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {                        
          return value!.isEmpty ? 'Required field' : null;
        },
      ),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(Icons.date_range),
            SizedBox(width: 20.0),
            InkWell(
              child: state.ticket!.arrivalDatetime != null 
                ? Text('${DateFormat.yMMMd().format(state.ticket!.arrivalDatetime!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Date', style: quicksandStyle(fontSize: 18.0)),
              onTap: () => _selectArrivalDate(context, state, widget.trip)
            )])
        ),
        Container(
          width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(Icons.schedule),
            SizedBox(width: 20.0),
            InkWell(
              child: state.ticket!.arrivalDatetime != null 
                ? Text('${DateFormat.Hm().format(state.ticket!.arrivalDatetime!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Time', style: quicksandStyle(fontSize: 18.0)),
              onTap: () => _selectArrivalTime(context, state, widget.trip),
            )]),
        )
      ])
    ]
  );

  Widget _carrierDetails(TicketEditState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Carrier', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., CP"                      
              ),
              style:  quicksandStyle(fontSize: 18.0),
              controller: _carrierController
            )
          )
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Carrier #', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., AB123"                      
              ),
              style:  quicksandStyle(fontSize: 18.0),
              controller: _carrierNumberController
            )
          )
        ])
      ])
    ]
  );

  Widget _seatsDetails(TicketEditState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Qty', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., 2"                      
              ),                            
              style:  quicksandStyle(fontSize: 18.0),
              controller: _quantityController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (int.tryParse(value!) == null) return 'Should be a number';                              
              }
            )
          )
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Seats', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., 25A, 25B"                      
              ),
              style:  quicksandStyle(fontSize: 18.0),
              controller: _seatsController
            )
          )
        ])
      ])
    ]
  );

  Widget _reservationdetails(TicketEditState state) => new Column(
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
          hintText: "e.g., www.traces.com/ticket/123"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _reservUrlController
      ),
      SizedBox(height: 10.0),
      Text('Details', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., platform, gate, etc."                      
        ),
        minLines: 5,
        maxLines: 10,
        style:  quicksandStyle(fontSize: 18.0),
        controller: _detailsController
      )
    ]
  );

  Future<Null> _selectDepDate(
    BuildContext context, TicketEditState state, Trip trip) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker (
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,   
      initialDate: state.ticket!.departureDatetime ?? trip.startDate ?? DateTime.now(),      
      firstDate: trip.startDate ?? DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),        
    );
    if (picked != null) {
      var time = TimeOfDay.fromDateTime(state.ticket!.departureDatetime ?? DateTime.now());
      var ticketDate = new DateTime.utc(picked.year, picked.month, picked.day, time.hour, time.minute);
      context.read<TicketEditBloc>().add(DepartureDateUpdated(ticketDate));      
    }
  }

  Future<Null> _selectArrivalDate(
    BuildContext context, TicketEditState state, Trip trip) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker (   
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },     
      context: context,   
      initialDate: state.ticket!.arrivalDatetime ?? trip.startDate ?? DateTime.now(),      
      firstDate: trip.startDate ?? DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),        
    );
    if (picked != null) {
      var time = TimeOfDay.fromDateTime(state.ticket!.arrivalDatetime ?? DateTime.now());
      var ticketDate = new DateTime.utc(picked.year, picked.month, picked.day, time.hour, time.minute);
      context.read<TicketEditBloc>().add(ArrivalDateUpdated(ticketDate));      
    }
  }

  Future<Null> _selectDepTime(BuildContext context, TicketEditState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.ticket!.departureDatetime ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.ticket!.departureDatetime != null){      
        var date = state.ticket!.departureDatetime!;
        var ticketDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<TicketEditBloc>().add(DepartureDateUpdated(ticketDate));    
      }
      
    }
  }

  Future<Null> _selectArrivalTime(BuildContext context, TicketEditState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.ticket!.arrivalDatetime ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.ticket!.arrivalDatetime != null){      
        var date = state.ticket!.arrivalDatetime!;
        var ticketDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<TicketEditBloc>().add(ArrivalDateUpdated(ticketDate));    
      }
      
    }
  }

  Widget _expenseDetails(TicketEditState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Expense', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text('${state.ticket!.expense!.amount} ${state.ticket!.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
        IconButton(onPressed: (){
          showDialog(                
            barrierDismissible: false, context: context, builder: (_) =>
              BlocProvider<ExpenseCreateBloc>(
                create: (context) => ExpenseCreateBloc()..add(AddExpenseMode(state.ticket!.expense!.category!.name, state.ticket!.expense!)),
                  child: CreateExpenseDialog(trip: widget.trip, submitExpense: false, callback: (val) async {
                    if(val != null){
                      context.read<TicketEditBloc>().add(ExpenseUpdated(val));
                    }
                  }),
              )
          );
        }, icon: Icon(Icons.edit, color: ColorsPalette.juicyOrange)),
        IconButton(onPressed: (){
          context.read<TicketEditBloc>().add(ExpenseUpdated(null));
        }, 
        icon: Icon(Icons.close, color: ColorsPalette.black))
      ],),      
    ]
  );

  Ticket createTicketModel(TicketEditState state){
    return state.ticket!.copyWith(
      departureLocation: _depLocationController!.text.trim(),
      arrivalLocation: _arrivalLocationController!.text.trim(),
      carrier: _carrierController!.text.trim(),
      carrierNumber: _carrierNumberController!.text.trim(),
      reservationNumber: _reservNumberController!.text.trim(),
      reservationUrl: _reservUrlController!.text.trim(),
      details: _detailsController!.text.trim(),
      seats: _seatsController!.text.trim(),
      quantity: int.parse(_quantityController!.text.trim()),
      type: state.ticket!.type ?? TripSettings.ticketType.first
    );   
  } 

}