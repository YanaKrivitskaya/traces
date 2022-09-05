
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/settings/categories/repository/api_categories_repository.dart';
import 'package:traces/screens/trips/model/api_models/currency.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/screens/trips/repository/api_expenses_repository.dart';
import 'package:traces/screens/trips/repository/currency_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'expensecreate_event.dart';
part 'expensecreate_state.dart';

class ExpenseCreateBloc extends Bloc<ExpenseCreateEvent, ExpenseCreateState> {
  final ApiExpensesRepository _expensesRepository;
  final CurrencyRepository _currencyRepository;
  final ApiCategoriesRepository _categoriesRepository;

  ExpenseCreateBloc() : 
  _expensesRepository = new ApiExpensesRepository(),
  _currencyRepository = new CurrencyRepository(),
  _categoriesRepository = new ApiCategoriesRepository(),
  super(ExpenseCreateInitial(null, null, null)){
    on<NewExpenseMode>(_onNewExpenseMode);
    on<EditExpenseMode>(_onEditExpenseMode);
    on<DateUpdated>(_onDateUpdated);
    on<ExpenseSubmitted>(_onExpenseSubmitted);
    on<PaidUpdated>(_onPaidUpdated);
    on<AddExpenseMode>(_onAddExpenseMode);
  }  

  void _onNewExpenseMode(NewExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    emit(ExpenseCreateEdit(null, null, true, null));
    List<Category>? categories = await _categoriesRepository.getCategories();
    List<Currency>? currencies = await _currencyRepository.getCurrencies();

    emit(ExpenseCreateEdit(new Expense(date: event.date ?? DateTime.now()), categories, false, currencies));
  } 

  void _onEditExpenseMode(EditExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<Category>? categories = await _categoriesRepository.getCategories();
    List<Currency>? currencies = await _currencyRepository.getCurrencies();

    emit(ExpenseCreateEdit(event.expense, categories, false, currencies));
  } 


  void _onAddExpenseMode(AddExpenseMode event, Emitter<ExpenseCreateState> emit) async{
    List<Category>? categories = await _categoriesRepository.getCategories();
    List<Currency>? currencies = await _currencyRepository.getCurrencies();

    Expense newExpense;

    if(event.category != null){
      Category? category = categories!.firstWhere((c) => c.name == event.category, orElse: () => new Category(name: event.category));
      newExpense = event.expense!.copyWith(category: category);
    }else{
      newExpense = event.expense!;
    }

    emit(ExpenseCreateEdit(newExpense, categories, false, currencies));
  } 

  void _onDateUpdated(DateUpdated event, Emitter<ExpenseCreateState> emit) async{
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(date: event.date);

    emit(ExpenseCreateEdit(updExpense, state.categories, false, state.currencies));
  } 

  void _onPaidUpdated(PaidUpdated event, Emitter<ExpenseCreateState> emit) async{
    Expense expense = state.expense ?? new Expense();

    Expense updExpense = expense.copyWith(isPaid: event.isPaid);

    emit(ExpenseCreateEdit(updExpense, state.categories, false, state.currencies));
  } 

  void _onExpenseSubmitted(ExpenseSubmitted event, Emitter<ExpenseCreateState> emit) async{
    emit(ExpenseCreateEdit(event.expense, state.categories, true, state.currencies));
    print(event.expense.toString());

    var category = event.expense!.category!;

    try{
      if(category.id == null){
        category = (await _categoriesRepository.createCategory(event.expense!.category!))!;
      }
      Expense expense;      

      if(event.expense!.amount != null && event.defaultCurrency != null){
        if(event.expense!.currency != event.defaultCurrency){
          var currencyRate = await _currencyRepository.convert(event.expense!.currency!, event.defaultCurrency!, event.expense!.amount!);
          event.expense = event.expense!.copyWith(amountDTC: currencyRate.rateAmount);
        }else{
          event.expense = event.expense!.copyWith(amountDTC: event.expense!.amount);
        }        
      }      

      if(event.expense!.id != null){
        expense = await _expensesRepository.updateExpense(event.expense!, event.tripId, category.id!);
      }else{
        expense = await _expensesRepository.createExpense(event.expense!, event.tripId, category.id!);
      }
      
      emit(ExpenseCreateSuccess(expense, state.categories, state.currencies));
    }on CustomException catch(e){
      emit(ExpenseCreateError(event.expense, state.categories, e.toString(), state.currencies));
    }  
  } 
}
