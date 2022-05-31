
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/settings/categories/repository/api_categories_repository.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'expensecreate_event.dart';
part 'expensecreate_state.dart';

class ExpenseCreateBloc extends Bloc<ExpenseCreateEvent, ExpenseCreateState> {
  final ApiExpensesRepository _expensesRepository;
  final ApiCategoriesRepository _categoriesRepository;

  ExpenseCreateBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  _categoriesRepository = new ApiCategoriesRepository(),
  super(ExpenseCreateInitial(null, null)){
    on<NewExpenseMode>(_onNewExpenseMode);
    on<EditExpenseMode>(_onEditExpenseMode);
    on<DateUpdated>(_onDateUpdated);
    on<ExpenseSubmitted>(_onExpenseSubmitted);
    on<PaidUpdated>(_onPaidUpdated);
    on<AddExpenseMode>(_onAddExpenseMode);
  }  

  void _onNewExpenseMode(NewExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<Category>? categories = await _categoriesRepository.getCategories();

    emit(ExpenseCreateEdit(new Expense(date: event.date), categories, false));
  } 

  void _onEditExpenseMode(EditExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<Category>? categories = await _categoriesRepository.getCategories();

    emit(ExpenseCreateEdit(event.expense, categories, false));
  } 


  void _onAddExpenseMode(AddExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<Category>? categories = await _categoriesRepository.getCategories();

    Expense newExpense;

    if(event.category != null){
      Category? category = categories!.firstWhere((c) => c.name == event.category, orElse: () => new Category(name: event.category));
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
        category = (await _categoriesRepository.createCategory(event.expense!.category!))!;
      }
      Expense expense = await _expensesRepository.createExpense(event.expense!, event.tripId, category.id!);
      emit(ExpenseCreateSuccess(expense, state.categories));
    }on CustomException catch(e){
      emit(ExpenseCreateError(event.expense, state.categories, e.toString()));
    }  
  } 
}
