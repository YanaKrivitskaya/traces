part of 'expensecreate_bloc.dart';

@immutable
abstract class ExpenseCreateEvent {
  List<Object?> get props => [];
}

class NewExpenseMode extends ExpenseCreateEvent {
  final DateTime? date;
 
  NewExpenseMode(this.date);

  List<Object?> get props => [date];
}

class AddExpenseMode extends ExpenseCreateEvent {
  final String? category;
  late final Expense? expense;

  AddExpenseMode(this.category, this.expense);

  List<Object?> get props => [category, expense];
}


class DateUpdated extends ExpenseCreateEvent {
  final DateTime date;

  DateUpdated(this.date);

  List<Object> get props => [date];
}

class PaidUpdated extends ExpenseCreateEvent {
  final bool isPaid;

  PaidUpdated(this.isPaid);

  List<Object> get props => [isPaid];
}

class ExpenseSubmitted extends ExpenseCreateEvent {
  final Expense? expense;
  final int tripId;  
  
  ExpenseSubmitted(this.expense, this.tripId);

  List<Object?> get props => [expense, tripId,];
}
