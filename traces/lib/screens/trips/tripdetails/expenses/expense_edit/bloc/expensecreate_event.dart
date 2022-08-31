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

class EditExpenseMode extends ExpenseCreateEvent {
  final Expense expense;
 
  EditExpenseMode(this.expense);

  List<Object?> get props => [expense];
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
  Expense? expense;
  final int tripId;  
  final String? defaultCurrency;
  
  ExpenseSubmitted(this.expense, this.tripId, this.defaultCurrency);

  List<Object?> get props => [expense, tripId, defaultCurrency];
}
