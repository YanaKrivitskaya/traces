

import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/services/api_service.dart';

class ApiCategoriesRepository{
  ApiService apiProvider = ApiService();
  String categoriesUrl = 'categories/';

    Future<List<Category>?> getCategories() async{    
    print("getCategories");    
   
    final response = await apiProvider.getSecure(categoriesUrl);
      
    var categoryResponse = response["categories"] != null ? 
      response['categories'].map<Category>((map) => Category.fromMap(map)).toList() : null;
    return categoryResponse;
  }

  Future<Category?> createCategory(Category category)async{
    print("createCategory");    

    final response = await apiProvider.postSecure(categoriesUrl, category.toJson());
      
    var categoryResponse = response["category"] != null ? 
      Category.fromMap(response['category']) : null;
    return categoryResponse;
  }

  Future<Category?> updateCategory(Category category)async{
    print("updateCategory");    

    final response = await apiProvider.putSecure(categoriesUrl, category.toJson());
      
    var categoryResponse = response["category"] != null ? 
      Category.fromMap(response['category']) : null;
    return categoryResponse;
  }
}