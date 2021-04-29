part of 'startplanning_bloc.dart';

@immutable
abstract class StartPlanningState extends Equatable{
  const StartPlanningState();

  @override
  List<Object> get props => [];
}

class StartPlanningInitial extends StartPlanningState {}

class StartPlanningSuccessState extends StartPlanningState{
  final Trip trip;

  StartPlanningSuccessState(this.trip);

  @override
  List<Object> get props => [trip];

}

class StartPlanningErrorState extends StartPlanningState{
  final String error;

  StartPlanningErrorState(this.error);

  @override
  List<Object> get props => [error];

}