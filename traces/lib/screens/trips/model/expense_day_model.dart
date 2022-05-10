
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

class ExpenseDay{
  final DateTime date;
  final List<Expense> expenses;
  final List<String> expenseTotalList;

  ExpenseDay(this.date, this.expenses, this.expenseTotalList);

}