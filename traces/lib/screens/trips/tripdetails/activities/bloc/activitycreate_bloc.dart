import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/activity_category.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/repository/api_activities_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'activitycreate_event.dart';
part 'activitycreate_state.dart';

class ActivityCreateBloc extends Bloc<ActivityCreateEvent, ActivityCreateState> {
  final ApiActivitiesRepository _activitiesRepository;
  final ApiProfileRepository _profileRepository;
  
  ActivityCreateBloc() : 
  _activitiesRepository = new ApiActivitiesRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(ActivityCreateInitial(null, null));

  @override
  Stream<ActivityCreateState> mapEventToState(
    ActivityCreateEvent event,
  ) async* {
    if (event is NewActivityMode) {
      yield* _mapNewActivityModeToState(event);
    } else if (event is DateUpdated) {
      yield* _mapArrivalDateUpdatedToState(event);
    } else if (event is PlannedUpdated) {
      yield* _mapPlannedUpdatedToState(event);
    }  else if (event is CompletedUpdated) {
      yield* _mapCompletedUpdatedToState(event);
    }else if (event is ActivitySubmitted) {
      yield* _mapActivitySubmittedToState(event);
    }
  }

   Stream<ActivityCreateState> _mapNewActivityModeToState(NewActivityMode event) async* {
    List<ActivityCategory>? categories = await _activitiesRepository.getActivityCategories();
    yield ActivityCreateEdit(new Activity(), categories, false);
  }

  Stream<ActivityCreateState> _mapArrivalDateUpdatedToState(DateUpdated event) async* {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(date: event.date);

    yield ActivityCreateEdit(updActivity, state.categories, false);
  }

  Stream<ActivityCreateState> _mapPlannedUpdatedToState(PlannedUpdated event) async* {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(isPlanned: event.isPlanned);

    yield ActivityCreateEdit(updActivity, state.categories, false);
  }

    Stream<ActivityCreateState> _mapCompletedUpdatedToState(CompletedUpdated event) async* {
    
    Activity activity = state.activity ?? new Activity();

    Activity updActivity = activity.copyWith(isCompleted: event.isCompleted);

    yield ActivityCreateEdit(updActivity, state.categories, false);
  }


  Stream<ActivityCreateState> _mapActivitySubmittedToState(ActivitySubmitted event) async* {
    yield ActivityCreateEdit(event.activity, state.categories, true);
    
    var category = event.activity!.category;

    try{
      if(category != null && category.id == null){
        category = (await _activitiesRepository.createActivityCategory(category))!;
      }
      Activity activity = await _activitiesRepository.createActivity(event.activity!, event.expense, event.tripId, category?.id);
      yield ActivityCreateSuccess(activity, state.categories);
    }on CustomException catch(e){
        yield ActivityCreateError(event.activity, state.categories, e.toString());
    }    
  }
}
