part of 'expensecreate_bloc.dart';

abstract class ExpenseCreateState {
  Expense? expense;
  List<Category>? categories;
  List<Currency>? currencies;

  ExpenseCreateState(this.expense, this.categories, this.currencies);

  @override
  List<Object?> get props => [expense, categories, currencies];
}

class ExpenseCreateInitial extends ExpenseCreateState {
  ExpenseCreateInitial(Expense? expense, List<Category>? categories, List<Currency>? currencies) : super(expense, categories, currencies);
}

class ExpenseCreateEdit extends ExpenseCreateState {
  final bool loading;

  ExpenseCreateEdit(Expense? expense, List<Category>? categories, this.loading, List<Currency>? currencies) : super(expense, categories, currencies);

  @override
  List<Object?> get props => [expense, categories, loading, currencies];
}

class ExpenseCreateError extends ExpenseCreateState {
  final String error;

  ExpenseCreateError(Expense? expense, List<Category>? categories, this.error, List<Currency>? currencies) : super(expense, categories, currencies);

  @override
  List<Object?> get props => [expense, categories, error, currencies];
}

class ExpenseCreateSuccess extends ExpenseCreateState {

  ExpenseCreateSuccess(Expense? expense, List<Category>? categories, List<Currency>? currencies) : super(expense, categories, currencies);

  @override
  List<Object?> get props => [expense, categories, currencies];
}
