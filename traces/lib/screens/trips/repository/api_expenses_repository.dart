import 'package:traces/screens/trips/model/api_models/api_expense.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';

import '../../../utils/services/api_service.dart';

class ApiExpensesRepository{
  ApiService apiProvider = ApiService();
  String expensesUrl = 'expenses/';

  Future<List<Expense>?> getTripExpenses(int tripId) async{    
    print("getTripExpenses");
    
    final queryParameters = {
      'tripId': tripId.toString()
    };
    final response = await apiProvider.getSecure(expensesUrl, queryParams: queryParameters);
      
    var expenseResponse = response["expenses"] != null ? 
      response['expenses'].map<Expense>((map) => Expense.fromMap(map)).toList() : null;
    return expenseResponse;
  }

  Future<Expense?> getExpenseById(int expenseId) async{
    print("getExpenseById");
    final response = await apiProvider.getSecure("$expensesUrl$expenseId");
      
    var expenseResponse = response["expense"] != null ? 
      Expense.fromMap(response['expense']) : null;
    return expenseResponse;
    }

  Future<Expense> createExpense(Expense expense, int tripId, int categoryId)async{
    print("createExpense");

    ApiExpenseModel apiModel = ApiExpenseModel(expense: expense, tripId: tripId, categoryId: categoryId);

    final response = await apiProvider.postSecure(expensesUrl, apiModel.toJson());
      
    var expenseResponse = Expense.fromMap(response['expenses']);
    return expenseResponse;
  }

  Future<Expense> updateExpense(Expense expense)async{
    print("updateExpense");

    final response = await apiProvider.putSecure("$expensesUrl${expense.id}", expense.toJson());
      
    var expenseResponse = Expense.fromMap(response['expenses']);
    return expenseResponse;
  }

  Future<String?> deleteExpense(int expenseId)async{
    print("deleteExpense");   

    final response = await apiProvider.deleteSecure("$expensesUrl$expenseId}");     
    
    return response["response"];
  } 
}