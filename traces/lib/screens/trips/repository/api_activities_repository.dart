

import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/activity_category.model.dart';
import 'package:traces/screens/trips/model/api_models/api_activity.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

import '../../../utils/services/api_service.dart';

class ApiActivitiesRepository{
  ApiService apiProvider = ApiService();
  String activitiesUrl = 'activities/';
  String activityCategoryUrl = 'activity-categories/';

  Future<List<Activity>?> getTripActivities(int tripId) async{    
    print("getTripActivities");
    
    final queryParameters = {
      'tripid': tripId
    };
    final response = await apiProvider.getSecure(activitiesUrl, queryParams: queryParameters);
      
    var activityResponse = response["activities"] != null ? 
      response['activities'].map<Activity>((map) => Activity.fromMap(map)).toList() : null;
    return activityResponse;
  }

  Future<List<ActivityCategory>?> getActivityCategories() async{    
    print("getActivityCategories");    
   
    final response = await apiProvider.getSecure(activityCategoryUrl);
      
    var activityResponse = response["categories"] != null ? 
      response['categories'].map<ActivityCategory>((map) => ActivityCategory.fromMap(map)).toList() : null;
    return activityResponse;
  }

  Future<Activity?> getActivityById(int activityId) async{
    print("getActivityById");
    final response = await apiProvider.getSecure("$activitiesUrl$activityId");
      
    var activityResponse = response["activity"] != null ? 
      Activity.fromMap(response['activity']) : null;
    return activityResponse;
  }

    Future<Activity> createActivity(Activity activity, Expense? expense, int tripId, int? categoryId)async{
    print("createActivity");

    ApiActivityModel apiModel = ApiActivityModel(activity: activity, expense: expense, tripId: tripId, categoryId: categoryId);

    final response = await apiProvider.postSecure(activitiesUrl, apiModel.toJson());
      
    var activityResponse = Activity.fromMap(response['activities']);
    return activityResponse;
  }

  Future<Activity> updateActivity(Activity activity)async{
    print("updateActivity");

    final response = await apiProvider.putSecure("$activitiesUrl${activity.id}", activity.toJson());
      
    var activityResponse = Activity.fromMap(response['activities']);
    return activityResponse;
  }

  Future<String?> deleteActivity(int activityId)async{
    print("deleteActivity");   

    final response = await apiProvider.deleteSecure("$activitiesUrl$activityId}");     
    
    return response["response"];
  } 
}