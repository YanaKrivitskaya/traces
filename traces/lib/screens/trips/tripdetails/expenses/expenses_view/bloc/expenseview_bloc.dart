import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'expenseview_event.dart';
part 'expenseview_state.dart';

class ExpenseViewBloc extends Bloc<ExpenseViewEvent, ExpenseViewState> {
  final ApiExpensesRepository _expensesRepository;

  ExpenseViewBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  super(ExpenseViewInitial(null)) {
    on<GetExpenseDetails>((event, emit) async{
      emit(ExpenseViewLoading(state.expense));
      try{
        Expense? activity = await _expensesRepository.getExpenseById(event.expenseId);
              
        emit(ExpenseViewSuccess(activity));
              
      }on CustomException catch(e){
        emit(ExpenseViewError(state.expense, e.toString()));
      }
    });
  }
}
