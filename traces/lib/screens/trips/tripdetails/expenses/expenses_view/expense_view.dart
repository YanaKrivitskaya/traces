import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/expenses/expenses_view/bloc/expenseview_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class ExpenseView extends StatefulWidget{
  final Trip trip; 

  ExpenseView({required this.trip});

  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView>{
  Expense? expense;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseViewBloc, ExpenseViewState>(
      listener: (context, state){
        if(state.expense != null) expense = state.expense!;

        if(state is ExpenseViewError){
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
      child: BlocBuilder<ExpenseViewBloc, ExpenseViewState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Expense details',
                style: quicksandStyle(fontSize: 25.0)),
              backgroundColor: ColorsPalette.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: ColorsPalette.black),
                onPressed: ()=> Navigator.pop(context)
              ),
              actions: expense != null ? [
                IconButton(onPressed: (){
                  ExpenseEditArguments args = new ExpenseEditArguments(trip: widget.trip, expense: expense!);
                  Navigator.pushNamed(context, expenseEditRoute, arguments: args).then((value){
                    value != null ? context.read<ExpenseViewBloc>().add(GetExpenseDetails(expense!.id!)) : '';
                  });
                }, icon: Icon(Icons.edit_outlined, color: ColorsPalette.black)),
                IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline, color: ColorsPalette.black))
              ] : [],
            ),
            
            body: expense != null ? Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(child: _expenseDetails(expense!)),
            ) : loadingWidget(ColorsPalette.juicyYellow),
          );
        },
      ),
    );
  }

  Widget _expenseDetails(Expense expense){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [     
      /*Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Check In', style: quicksandStyle(fontSize: 20.0)),
          Text('${DateFormat.yMMMd().format(expense.entryDate!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],)  
      ),
      Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [        
        Text('${expense.location ?? ''}', style: quicksandStyle(fontSize: 18.0)),
        Text(expense.name ?? '', style: quicksandStyle(fontSize: 18.0)),
        expense.reservationNumber != '' ? Text('Reservation #: ${expense.reservationNumber}', style: quicksandStyle(fontSize: 18.0)) : Container(),
        expense.reservationUrl != '' ? SelectableText('Reservation Url: ${expense.reservationUrl}', style: quicksandStyle(fontSize: 18.0)) : Container(),
        Text(expense.details ?? '', style: quicksandStyle(fontSize: 18.0))        
      ],)),
      Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Check Out', style: quicksandStyle(fontSize: 20.0)),
          Text('${DateFormat.yMMMd().format(expense.exitDate!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],)  
      ),
      Divider(color: ColorsPalette.juicyBlue),*/
      
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(expense.isPaid! ? 'Paid' : 'Planned', style: quicksandStyle(color: expense.isPaid! ? ColorsPalette.juicyGreen : ColorsPalette.juicyOrangeDark, fontSize: 20.0)),
        SizedBox(height: 5.0),
        Divider(color: ColorsPalette.juicyGreen),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Date', style: quicksandStyle(fontSize: 20.0)),
          Text('${DateFormat.yMMMd().format(expense.date!)}', 
            style: quicksandStyle(fontSize: 20.0))
        ],),
        SizedBox(height: 5.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Category', style: quicksandStyle(fontSize: 20.0)),
          Text('${expense.category?.name}', 
            style: quicksandStyle(fontSize: 20.0))
        ],),
        SizedBox(height: 5.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Amount', style: quicksandStyle(fontSize: 20.0)),
            Text('${expense.amount} ${expense.currency}', style: quicksandStyle(fontSize: 18.0)),            
          ])        
      ],)
    ],

    );  
    return Container();  
  }
}