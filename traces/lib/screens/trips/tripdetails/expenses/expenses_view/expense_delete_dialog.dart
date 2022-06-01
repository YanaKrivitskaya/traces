import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/tripdetails/expenses/expenses_view/bloc/expenseview_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:intl/intl.dart';

class ExpenseDeleteDialog extends StatefulWidget{
  final Expense expense;
  final StringCallback? callback;

  ExpenseDeleteDialog({required this.expense, this.callback});

  @override
  _ExpenseDeleteDialogViewState createState() => _ExpenseDeleteDialogViewState();

}

class _ExpenseDeleteDialogViewState extends State<ExpenseDeleteDialog>{


  @override
  Widget build(BuildContext context) {
    late String errorText;
    bool showError = false;

    return BlocListener<ExpenseViewBloc, ExpenseViewState>(
      listener: (context, state) {
        if(state is ExpenseViewError){
          errorText = state.error;
          showError = true;
        }
        if(state is ExpenseViewSuccess){          
          showError = false;
        }
        if(state is ExpenseViewDeleted){          
          widget.callback!('Ok');
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ExpenseViewBloc, ExpenseViewState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text("Delete expense?"),
            content: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${DateFormat.yMMMd().format(widget.expense.date!)}'),
                Text('${widget.expense.category?.name}'),
                Text('${widget.expense.amount} ${widget.expense.currency}'),
                SizedBox(height: 20.0,),
                Divider(color: ColorsPalette.juicyOrange),
                showError ? Text(errorText, style: quicksandStyle(color: ColorsPalette.redPigment)) : Container(),
              ]),              
            ),
            actions: [
              TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.juicyDarkBlue)),
              onPressed: () {
                context.read<ExpenseViewBloc>()..add(DeleteExpense(widget.expense));               
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.juicyDarkBlue),),
              onPressed: () {                
                Navigator.pop(context);
              },
            ),
            ],
          );
        },
      )
    );
  }
  
}