part of 'expenseview_bloc.dart';

@immutable
abstract class ExpenseViewEvent {}

class GetExpenseDetails extends ExpenseViewEvent {
  final int expenseId;

  GetExpenseDetails(this.expenseId);

  List<Object> get props => [expenseId];
}

class DeleteExpense extends ExpenseViewEvent {
  final Expense expense;

  DeleteExpense(this.expense);

  List<Object> get props => [expense];
}
