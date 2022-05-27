import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/repository/api_activities_repository.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../model/category.model.dart';

part 'activitycreate_event.dart';
part 'activitycreate_state.dart';

class ActivityCreateBloc extends Bloc<ActivityCreateEvent, ActivityCreateState> {
  final ApiActivitiesRepository _activitiesRepository;
  final ApiProfileRepository _profileRepository;
  
  ActivityCreateBloc() : 
  _activitiesRepository = new ApiActivitiesRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(ActivityCreateInitial(null, null)){
    on<NewActivityMode>(_onNewActivityMode);
    on<EditActivityMode>(_onEditActivityMode);
    on<ActivityDateUpdated>(_onActivityDateUpdated);
    on<PlannedUpdated>(_onPlannedUpdated);
    on<CompletedUpdated>(_onCompletedUpdated);
    on<ExpenseUpdated>(_onExpenseUpdated);
    on<ActivitySubmitted>(_onActivitySubmitted);
  } 

   void _onNewActivityMode(NewActivityMode event, Emitter<ActivityCreateState> emit) async {
    List<Category>? categories = await _activitiesRepository.getActivityCategories();
    emit(ActivityCreateEdit(new Activity(date: event.date), categories, false));
  }

   void _onEditActivityMode(EditActivityMode event, Emitter<ActivityCreateState> emit) async {
    List<Category>? categories = await _activitiesRepository.getActivityCategories();
    emit(ActivityCreateEdit(event.activity, categories, false));
  }

  void _onActivityDateUpdated(ActivityDateUpdated event, Emitter<ActivityCreateState> emit) async {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(date: event.date);

    emit(ActivityCreateEdit(updActivity, state.categories, false));
  }

  void _onPlannedUpdated(PlannedUpdated event, Emitter<ActivityCreateState> emit) async {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(isPlanned: event.isPlanned);

    emit(ActivityCreateEdit(updActivity, state.categories, false));
  }

    void _onCompletedUpdated(CompletedUpdated event, Emitter<ActivityCreateState> emit) async {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(isCompleted: event.isCompleted);

    emit(ActivityCreateEdit(updActivity, state.categories, false));
  }

  void _onExpenseUpdated(ExpenseUpdated event, Emitter<ActivityCreateState> emit) async {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(expense: event.expense);

    emit(ActivityCreateEdit(updActivity, state.categories, false));
  }


  void _onActivitySubmitted(ActivitySubmitted event, Emitter<ActivityCreateState> emit) async {
    emit(ActivityCreateEdit(event.activity, state.categories, true));
    
    var category = event.activity!.category;

    try{
      if(category != null && category.id == null){
        category = (await _activitiesRepository.createActivityCategory(category))!;
      }
      Activity activity;
      if(state.activity!.id != null){
        activity = await _activitiesRepository.updateActivity(event.activity!, event.expense, event.tripId, category?.id);
      }else{
        activity = await _activitiesRepository.createActivity(event.activity!, event.expense, event.tripId, category?.id);
      }      
      emit(ActivityCreateSuccess(activity, state.categories));
    }on CustomException catch(e){
        emit(ActivityCreateError(event.activity, state.categories, e.toString()));
    }    
  }
}
