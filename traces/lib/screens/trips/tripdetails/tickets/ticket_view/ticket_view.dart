import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/tickets/ticket_view/bloc/ticketview_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TicketView extends StatefulWidget{
  Trip trip;

  TicketView({required this.trip});

  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView>{
  Ticket? ticket;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketViewBloc, TicketViewState>(
      listener: (context, state){
        if(state.ticket != null) ticket = state.ticket!;

        if(state is TicketViewError){
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
      child: BlocBuilder<TicketViewBloc, TicketViewState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Ticket details',
                style: quicksandStyle(fontSize: 25.0)),
              backgroundColor: ColorsPalette.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: ()=> Navigator.pop(context)
              ),
              actions: ticket != null ? [
                IconButton(onPressed: (){
                  TicketEditArguments args = new TicketEditArguments(trip: widget.trip, ticket: ticket!);
                  Navigator.pushNamed(context, ticketEditRoute, arguments: args).then((value){
                    value != null ? context.read<TicketViewBloc>().add(GetTicketDetails(ticket!.id!)) : '';
                  });
                }, icon: Icon(Icons.edit_outlined)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline))
              ] : null,
            ),
            
            body: ticket != null ? Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(child: _timelineTicket(ticket!)),
            ) : loadingWidget(ColorsPalette.juicyYellow),
          );
        },
      ),
    );
  }

  Widget _timelineTicket(Ticket ticket){
    bool sameDate = ticket.arrivalDatetime!.isSameDate(ticket.departureDatetime!);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(color: ColorsPalette.juicyBlue,),
      Container(padding: EdgeInsets.only(left: 25.0, right: 20.0), 
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          transportIcon(ticket.type, ColorsPalette.juicyBlue),
          sameDate ? Text('${DateFormat.yMMMd().format(ticket.departureDatetime!)}', 
            style: quicksandStyle(fontSize: 20.0)) : Container()
        ],)
      ),
      Container(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: ListView.builder(
        shrinkWrap: true,         
        itemCount: 2,
        itemBuilder: (context, position){          
          return TimelineTile(              
            alignment: TimelineAlign.start,
            lineXY: 0,
            isFirst: position == 0,
            isLast: position == 1,
            indicatorStyle: IndicatorStyle(
              indicator: Icon(Icons.radio_button_unchecked, size: 18.0, color: ColorsPalette.juicyBlue),              
              padding: EdgeInsets.all(5),
              indicatorXY: 0
            ),
            endChild: position == 0 ? _departureCard(ticket, sameDate) : _arrivalCard(ticket, sameDate),
            beforeLineStyle: const LineStyle(
              color: ColorsPalette.juicyBlue,
            ),
          );
      })),
      Divider(color: ColorsPalette.juicyBlue),
      ticket.expense != null ?
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Expense:', style: quicksandStyle(fontSize: 20.0)),
        SizedBox(height: 5.0),
        Row(children: [
            Text('${ticket.expense!.amount} ${ticket.expense!.currency}', style: quicksandStyle(fontSize: 18.0)),
            SizedBox(width: 20.0),
            Chip(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              backgroundColor: ticket.expense!.isPaid! ? ColorsPalette.natureGreenLight : ColorsPalette.juicyOrangeLight,
              label: Text(ticket.expense!.isPaid! ? 'Paid' : 'Planned', style: TextStyle(color: ticket.expense!.isPaid! ? ColorsPalette.juicyGreen : ColorsPalette.juicyOrangeDark)),
            ),
          ])        
      ],) : Container()
    ],

    );    
  }

  Widget _departureCard(Ticket ticket, bool sameDate) => new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('${DateFormat.Hm().format(ticket.departureDatetime!)}', 
        style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),
      !sameDate ? Text('${DateFormat.yMMMd().format(ticket.departureDatetime!)}', 
        style: quicksandStyle(fontSize: 20.0)) : Container()
    ],),      
    Text('${ticket.departureLocation}', style: quicksandStyle(fontSize: 16.0)),
    SizedBox(height: 10.0,),
    Text('${ticket.carrier ?? ''} ${ticket.carrierNumber ?? ''}', style: quicksandStyle(fontSize: 16.0)),
    Text('${ticket.seats != '' ? 'Seats ' + ticket.seats!  : ''}', style: quicksandStyle(fontSize: 16.0)),
    Text('${ticket.details ?? ''}', style: quicksandStyle(fontSize: 16.0)),
    SizedBox(height: 50.0,)
  ],);

  Widget _arrivalCard(Ticket ticket, bool sameDate) => new Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('${DateFormat.Hm().format(ticket.arrivalDatetime!)}', 
        style: quicksandStyle(fontSize: 20.0, weight: FontWeight.bold)),
      !sameDate ? Text('${DateFormat.yMMMd().format(ticket.arrivalDatetime!)}', 
        style: quicksandStyle(fontSize: 20.0)) : Container()
    ],),
    Text('${ticket.arrivalLocation}', style: quicksandStyle(fontSize: 16.0))      
  ],);

}