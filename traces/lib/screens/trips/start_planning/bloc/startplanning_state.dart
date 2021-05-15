part of 'startplanning_bloc.dart';

@immutable
abstract class StartPlanningState extends Equatable{
  final Trip trip;

  const StartPlanningState(this.trip);

  @override
  List<Object> get props => [trip];
}

class StartPlanningInitial extends StartPlanningState {
  StartPlanningInitial(Trip trip) : super(trip);
}

class StartPlanningSuccessState extends StartPlanningState{
  final bool loading;

  StartPlanningSuccessState(Trip trip, this.loading) : super(trip);

  @override
  List<Object> get props => [trip, loading];
}

class StartPlanningErrorState extends StartPlanningState{  
  final String error;

  StartPlanningErrorState(Trip trip, this.error) : super(trip);

  @override
  List<Object> get props => [trip, error];
}

class StartPlanningCreatedState extends StartPlanningState{
  StartPlanningCreatedState(Trip trip) : super(trip);

  @override
  List<Object> get props => [trip];

}