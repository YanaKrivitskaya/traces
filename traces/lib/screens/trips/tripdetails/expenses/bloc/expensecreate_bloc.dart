import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/api/customException.dart';
import '../../../model/expense.model.dart';
import '../../../repository/api_expenses_repository.dart';

part 'expensecreate_event.dart';
part 'expensecreate_state.dart';

class ExpenseCreateBloc extends Bloc<ExpenseCreateEvent, ExpenseCreateState> {
  final ApiExpensesRepository _expensesRepository;

  ExpenseCreateBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  super(ExpenseCreateInitial(null));

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
    }
  }

  Stream<ExpenseCreateState> _mapNewExpenseModeToState(NewExpenseMode event) async* {
    yield ExpenseCreateEdit(new Expense(), false);
  }

  Stream<ExpenseCreateState> _mapDateUpdatedToState(DateUpdated event) async* {
    
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(date: event.date);

    yield ExpenseCreateEdit(updExpense, false);
  }

  Stream<ExpenseCreateState> _mapPaidUpdatedToState(PaidUpdated event) async* {
    
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(isPaid: event.isPaid);

    yield ExpenseCreateEdit(updExpense, false);
  }

  Stream<ExpenseCreateState> _mapExpenseSubmittedToState(ExpenseSubmitted event) async* {
    yield ExpenseCreateEdit(event.expense, true);
    print(event.expense.toString());

    try{
      Expense expense = await _expensesRepository.createExpense(event.expense!, event.tripId);
      yield ExpenseCreateSuccess(expense);
    }on CustomException catch(e){
        yield ExpenseCreateError(event.expense, e.toString());
    }   
  }
}
