
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
  super(ActivityViewInitial(null)){
    on<GetActivityDetails>((event, emit) async{
      emit(ActivityViewLoading(state.activity));
      try{
        Activity? activity = await _activitiesRepository.getActivityById(event.activityId);
              
        emit(ActivityViewSuccess(activity));
              
      }on CustomException catch(e){
        emit(ActivityViewError(state.activity, e.toString()));
      }
    });
  }  
}
