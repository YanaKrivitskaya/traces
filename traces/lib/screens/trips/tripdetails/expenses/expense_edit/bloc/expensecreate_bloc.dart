
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/expense_category.model.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'expensecreate_event.dart';
part 'expensecreate_state.dart';

class ExpenseCreateBloc extends Bloc<ExpenseCreateEvent, ExpenseCreateState> {
  final ApiExpensesRepository _expensesRepository;

  ExpenseCreateBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  super(ExpenseCreateInitial(null, null)){
    on<NewExpenseMode>(_onNewExpenseMode);
    on<EditExpenseMode>(_onEditExpenseMode);
    on<DateUpdated>(_onDateUpdated);
    on<ExpenseSubmitted>(_onExpenseSubmitted);
    on<PaidUpdated>(_onPaidUpdated);
    on<AddExpenseMode>(_onAddExpenseMode);
  }  

  void _onNewExpenseMode(NewExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<ExpenseCategory>? categories = await _expensesRepository.getExpenseCategories();

    emit(ExpenseCreateEdit(new Expense(date: event.date), categories, false));
  } 

  void _onEditExpenseMode(EditExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<ExpenseCategory>? categories = await _expensesRepository.getExpenseCategories();

    emit(ExpenseCreateEdit(event.expense, categories, false));
  } 


  void _onAddExpenseMode(AddExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<ExpenseCategory>? categories = await _expensesRepository.getExpenseCategories();

    Expense newExpense;

    if(event.category != null){
      ExpenseCategory? category = categories!.firstWhere((c) => c.name == event.category, orElse: () => new ExpenseCategory(name: event.category));
      newExpense = event.expense!.copyWith(category: category);
    }else{
      newExpense = event.expense!;
    }

    emit(ExpenseCreateEdit(newExpense, categories, false));
  } 

  void _onDateUpdated(DateUpdated event, Emitter<ExpenseCreateState> emit) async{
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(date: event.date);

    emit(ExpenseCreateEdit(updExpense, state.categories, false));
  } 

  void _onPaidUpdated(PaidUpdated event, Emitter<ExpenseCreateState> emit) async{
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(isPaid: event.isPaid);

    emit(ExpenseCreateEdit(updExpense, state.categories, false));
  } 

  void _onExpenseSubmitted(ExpenseSubmitted event, Emitter<ExpenseCreateState> emit) async{
    emit(ExpenseCreateEdit(event.expense, state.categories, true));
    print(event.expense.toString());

    var category = event.expense!.category!;

    try{
      if(category.id == null){
        category = (await _expensesRepository.createExpenseCategory(event.expense!.category!))!;
      }
      Expense expense = await _expensesRepository.createExpense(event.expense!, event.tripId, category.id!);
      emit(ExpenseCreateSuccess(expense, state.categories));
    }on CustomException catch(e){
      emit(ExpenseCreateError(event.expense, state.categories, e.toString()));
    }  
  } 
}
