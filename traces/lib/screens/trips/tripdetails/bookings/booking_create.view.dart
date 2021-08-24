import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                Navigator.pop(context);
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
                title: Text('Create booking',
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
                          reservationNumber: _reservNumberController!.text.trim(),
                          reservationUrl: _reservUrlController!.text.trim(),
                          details: _detailsController!.text.trim(),                        
                          guestsQuantity: int.parse(_guestsQuantityController!.text.trim())
                        );                                    
                        context.read<BookingCreateBloc>().add(BookingSubmitted(newBooking, null, widget.trip.id!));
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
        width:  MediaQuery.of(context).size.width * 0.7,
        child:
        InkWell(      
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.date_range),
              state.booking?.entryDate != null 
                ?  Text('${DateFormat.yMMMd().format(state.booking!.entryDate!)}', style: quicksandStyle(fontSize: 18.0))
                : Text("Entry Date", style:  quicksandStyle(fontSize: 18.0)),
              Icon(Icons.date_range),
              state.booking?.exitDate != null 
                ?  Text('${DateFormat.yMMMd().format(state.booking!.exitDate!)}', style: quicksandStyle(fontSize: 18.0))
                : Text("End Date", style:  quicksandStyle(fontSize: 18.0)),
            ],
           ),
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
      context.read<BookingCreateBloc>().add(DateRangeUpdated(picked.start, picked.end));      
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
}