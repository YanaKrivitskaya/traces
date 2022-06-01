import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/expense_day_model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ExpensesView extends StatelessWidget{
 
  final List<Expense>? expenses;
  final Trip trip;
  ExpensesView(this.expenses, this.trip);   

  @override
  Widget build(BuildContext context) {

    List<ExpenseDay> expenseDays = [];

    if(expenses != null && expenses!.length > 0){
      Map<DateTime, List<Expense>> expensesList = expenses!.groupListsBy((element) => DateUtils.dateOnly(element.date!));

      expensesList.forEach((key, expenseGroup) {
        List<String> expenseListTotal = [];

        Map<String, List<Expense>> currencyGroups = expenseGroup.groupListsBy((element) => element.currency!);

        currencyGroups.forEach((key, group) {
          double sum = 0.0;      
          group.forEach((expense) {
            if(expense.isPaid != null && expense.isPaid!){
              sum += expense.amount!;
            }        
          });
          if(sum > 0) expenseListTotal.add(sum.toString() + ' ' + key);     
        });

        expenseDays.add(new ExpenseDay(
          key,
          expenseGroup,
          expenseListTotal
        ));
      });
    }

    expenseDays.sort((a, b) => a.date.compareTo(b.date));

    return RefreshIndicator(
      onRefresh: () async{
        BlocProvider.of<TripDetailsBloc>(context)..add(UpdateExpenses(trip.id!));
      },
      child: SingleChildScrollView(
        child: Column(children: [
          expenseDays.length > 0 ? 
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: expenseDays.length,              
                itemBuilder: (context, position){
                  final expenseDay = expenseDays[position];
                  return _expenseDay(expenseDay, context);                  
                }
              ),
            ) 
            : Container(
              padding: new EdgeInsets.all(25.0),
              child: Center(
                child: Container(child: Center(child: Text("No expenses", style: quicksandStyle(fontSize: 18.0)))),
              )
            )

        ],
      ),
    )
    );      
  }

  _expenseDay(ExpenseDay expenseDay, BuildContext context) => new Container(
    child: Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ColorsPalette.juicyGreen, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(padding: EdgeInsets.all(10.0),child: Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          Text('${DateFormat.yMMMd().format(expenseDay.date)}', style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold))
        ],),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
         for(var expenseTotal in expenseDay.expenseTotalList) Text(expenseTotal, style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold))
        ],)
      ],),
      Divider(color: ColorsPalette.juicyGreen),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: expenseDay.expenses.length,   
        itemBuilder: (context, idx){
          final expense = expenseDay.expenses[idx];
          return Column(            
            children: [     
              InkWell(
                onTap: (){
                  ExpenseViewArguments args = new ExpenseViewArguments(expenseId: expense.id!, trip: trip);

                  Navigator.of(context).pushNamed(expenseViewRoute, arguments: args).then((value) => {
                    BlocProvider.of<TripDetailsBloc>(context)..add(UpdateExpenses(trip.id!))
                  });
                },
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${DateFormat.Hm().format(expense.date!)}', style: quicksandStyle(fontSize: 15.0, weight: FontWeight.bold)),
                    SizedBox(width: 10.0),                         
                    Text('${expense.amount} ${expense.currency}', style: quicksandStyle(fontSize: 15.0)),
                  ],),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(children: [
                      Row(children: [
                        Icon(expense.category?.icon ?? Icons.category, color: expense.category?.color ?? ColorsPalette.black),
                        SizedBox(width: 4.0)                        
                      ],)                                            
                    ],),                    
                    Expanded(child: Text(
                      '${expense.category?.name} ${(expense.description != null && expense.description!.length > 0) ? ' - ' : ''} ${expense.description}', 
                      style: quicksandStyle(fontSize: 15.0)))                   
                  ],),
                  SizedBox(height: 10.0)
                ],) 
              )              
            ],
          );          
        }
      )
    ])))
  );

}
