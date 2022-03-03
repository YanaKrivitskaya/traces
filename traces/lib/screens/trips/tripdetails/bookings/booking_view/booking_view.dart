import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/bookings/booking_view/bloc/bookingview_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingView extends StatefulWidget{
  final Trip trip;

  BookingView({required this.trip});

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView>{
  Booking? booking;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingViewBloc, BookingViewState>(
      listener: (context, state){
        if(state.booking != null) booking = state.booking!;

        if(state is BookingViewError){
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
      child: BlocBuilder<BookingViewBloc, BookingViewState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Booking details',
                style: quicksandStyle(fontSize: 25.0)),
              backgroundColor: ColorsPalette.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: ()=> Navigator.pop(context)
              ),
              actions: booking != null ? [
                IconButton(onPressed: (){
                  BookingEditArguments args = new BookingEditArguments(trip: widget.trip, booking: booking!);
                  Navigator.pushNamed(context, bookingEditRoute, arguments: args).then((value){
                    value != null ? context.read<BookingViewBloc>().add(GetBookingDetails(booking!.id!)) : '';
                  });
                }, icon: Icon(Icons.edit_outlined)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline))
              ] : [],
            ),
            
            body: booking != null ? Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(child: _bookingDetails(booking!)),
            ) : loadingWidget(ColorsPalette.juicyYellow),
          );
        },
      ),
    );
  }

  Widget _bookingDetails(Booking booking){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(color: ColorsPalette.juicyBlue,),
      Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Check In', style: quicksandStyle(fontSize: 20.0)),
          Text('${DateFormat.yMMMd().format(booking.entryDate!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],)  
      ),
      Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [        
        Text('${booking.location ?? ''}', style: quicksandStyle(fontSize: 18.0)),
        Text(booking.name ?? '', style: quicksandStyle(fontSize: 18.0)),
        booking.reservationNumber != '' ? Text('Reservation #: ${booking.reservationNumber}', style: quicksandStyle(fontSize: 18.0)) : Container(),
        booking.reservationUrl != '' ? SelectableText('Reservation Url: ${booking.reservationUrl}', style: quicksandStyle(fontSize: 18.0)) : Container(),
        Text(booking.details ?? '', style: quicksandStyle(fontSize: 18.0))        
      ],)),
      Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Check Out', style: quicksandStyle(fontSize: 20.0)),
          Text('${DateFormat.yMMMd().format(booking.exitDate!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],)  
      ),
      Divider(color: ColorsPalette.juicyBlue),
      booking.expense != null ?
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Expense:', style: quicksandStyle(fontSize: 20.0)),
        SizedBox(height: 5.0),
        Row(children: [
            Text('${booking.expense!.amount} ${booking.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
            SizedBox(width: 20.0),
            Chip(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              backgroundColor: booking.expense!.isPaid! ? ColorsPalette.natureGreenLight : ColorsPalette.juicyOrangeLight,
              label: Text(booking.expense!.isPaid! ? 'Paid' : 'Planned', style: TextStyle(color: booking.expense!.isPaid! ? ColorsPalette.juicyGreen : ColorsPalette.juicyOrangeDark)),
            ),
          ])        
      ],) : Container()
    ],

    );    
  }
}