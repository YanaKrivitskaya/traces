part of 'expensecreate_bloc.dart';

abstract class ExpenseCreateState {
  Expense? expense;

  ExpenseCreateState(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseCreateInitial extends ExpenseCreateState {
  ExpenseCreateInitial(Expense? expense) : super(expense);
}

class ExpenseCreateEdit extends ExpenseCreateState {
  final bool loading;

  ExpenseCreateEdit(Expense? expense, this.loading) : super(expense);

  @override
  List<Object?> get props => [expense, loading];
}

class ExpenseCreateError extends ExpenseCreateState {
  final String error;

  ExpenseCreateError(Expense? expense, this.error) : super(expense);

  @override
  List<Object?> get props => [expense, error];
}

class ExpenseCreateSuccess extends ExpenseCreateState {

  ExpenseCreateSuccess(Expense? expense) : super(expense);

  @override
  List<Object?> get props => [expense];
}
