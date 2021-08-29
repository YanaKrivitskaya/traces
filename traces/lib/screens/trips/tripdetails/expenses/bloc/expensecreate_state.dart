part of 'expensecreate_bloc.dart';

abstract class ExpenseCreateState {
  Expense? expense;
  List<ExpenseCategory>? categories;

  ExpenseCreateState(this.expense, this.categories);

  @override
  List<Object?> get props => [expense, categories];
}

class ExpenseCreateInitial extends ExpenseCreateState {
  ExpenseCreateInitial(Expense? expense, List<ExpenseCategory>? categories) : super(expense, categories);
}

class ExpenseCreateEdit extends ExpenseCreateState {
  final bool loading;

  ExpenseCreateEdit(Expense? expense, List<ExpenseCategory>? categories, this.loading) : super(expense, categories);

  @override
  List<Object?> get props => [expense, categories, loading];
}

class ExpenseCreateError extends ExpenseCreateState {
  final String error;

  ExpenseCreateError(Expense? expense, List<ExpenseCategory>? categories, this.error) : super(expense, categories);

  @override
  List<Object?> get props => [expense, categories, error];
}

class ExpenseCreateSuccess extends ExpenseCreateState {

  ExpenseCreateSuccess(Expense? expense, List<ExpenseCategory>? categories) : super(expense, categories);

  @override
  List<Object?> get props => [expense, categories];
}
