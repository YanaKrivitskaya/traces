part of 'expenseview_bloc.dart';

abstract class ExpenseViewState {
  Expense? expense;

  ExpenseViewState(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseViewInitial extends ExpenseViewState {
  ExpenseViewInitial(Expense? expense) : super(expense);
}

class ExpenseViewLoading extends ExpenseViewState {
  ExpenseViewLoading(Expense? expense) : super(expense);
}

class ExpenseViewSuccess extends ExpenseViewState {

  ExpenseViewSuccess(Expense? expense) : super(expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseViewError extends ExpenseViewState {
  final String error;

  ExpenseViewError(Expense? expense, this.error) : super(expense);

  @override
  List<Object?> get props => [expense, error];
}
