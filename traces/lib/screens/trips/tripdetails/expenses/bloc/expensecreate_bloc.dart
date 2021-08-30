import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense_category.model.dart';

import '../../../../../utils/api/customException.dart';
import '../../../model/expense.model.dart';
import '../../../repository/api_expenses_repository.dart';

part 'expensecreate_event.dart';
part 'expensecreate_state.dart';

class ExpenseCreateBloc extends Bloc<ExpenseCreateEvent, ExpenseCreateState> {
  final ApiExpensesRepository _expensesRepository;

  ExpenseCreateBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  super(ExpenseCreateInitial(null, null));

  @override
  Stream<ExpenseCreateState> mapEventToState(
    ExpenseCreateEvent event,
  ) async* {
    if (event is NewExpenseMode) {
      yield* _mapNewExpenseModeToState(event);
    } else if (event is DateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is ExpenseSubmitted) {
      yield* _mapExpenseSubmittedToState(event);
    } else if (event is PaidUpdated) {
      yield* _mapPaidUpdatedToState(event);
    } else if (event is AddExpenseMode) {
      yield* _mapAddExpenseModeToState(event);
    }
  }

  Stream<ExpenseCreateState> _mapNewExpenseModeToState(NewExpenseMode event) async* {
    List<ExpenseCategory>? categories = await _expensesRepository.getExpenseCategories();

    yield ExpenseCreateEdit(new Expense(), categories, false);
  }

  Stream<ExpenseCreateState> _mapAddExpenseModeToState(AddExpenseMode event) async* {

    List<ExpenseCategory>? categories = await _expensesRepository.getExpenseCategories();

    Expense newExpense;

    if(event.category != null){
      ExpenseCategory? category = categories!.firstWhere((c) => c.name == event.category, orElse: () => new ExpenseCategory(name: event.category));
      newExpense = event.expense!.copyWith(category: category);
    }else{
      newExpense = event.expense!;
    }

    yield ExpenseCreateEdit(newExpense, categories, false);
  }

  Stream<ExpenseCreateState> _mapDateUpdatedToState(DateUpdated event) async* {
    
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(date: event.date);

    yield ExpenseCreateEdit(updExpense, state.categories, false);
  }

  Stream<ExpenseCreateState> _mapPaidUpdatedToState(PaidUpdated event) async* {
    
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(isPaid: event.isPaid);

    yield ExpenseCreateEdit(updExpense, state.categories, false);
  }

  Stream<ExpenseCreateState> _mapExpenseSubmittedToState(ExpenseSubmitted event) async* {
    yield ExpenseCreateEdit(event.expense, state.categories, true);
    print(event.expense.toString());

    var category = event.expense!.category!;

    try{
      if(category.id == null){
        category = (await _expensesRepository.createExpenseCategory(event.expense!.category!))!;
      }
      Expense expense = await _expensesRepository.createExpense(event.expense!, event.tripId, category.id!);
      yield ExpenseCreateSuccess(expense, state.categories);
    }on CustomException catch(e){
        yield ExpenseCreateError(event.expense, state.categories, e.toString());
    }   
  }
}
