import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/repository/api_activities_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'activityview_event.dart';
part 'activityview_state.dart';

class ActivityViewBloc extends Bloc<ActivityViewEvent, ActivityViewState> {
  final ApiActivitiesRepository _activitiesRepository;
  ActivityViewBloc() : 
  _activitiesRepository = new ApiActivitiesRepository(),
  super(ActivityViewInitial(null));

  @override
  Stream<ActivityViewState> mapEventToState(
    ActivityViewEvent event,
  ) async* {
    if (event is GetActivityDetails) {
      yield* _mapGetActivityDetailsToState(event);
    }
  }

  Stream<ActivityViewState> _mapGetActivityDetailsToState(GetActivityDetails event) async* {
    yield ActivityViewLoading(state.activity);
    try{
      Activity? activity = await _activitiesRepository.getActivityById(event.activityId);
            
      yield ActivityViewSuccess(activity);
            
    }on CustomException catch(e){
      yield ActivityViewError(state.activity, e.toString());
    }
      
  }
}
