part of 'startplanning_bloc.dart';

abstract class StartPlanningState{
  Trip? trip;
  final List<Currency>? currencies;

  StartPlanningState(this.trip, this.currencies);

  @override
  List<Object?> get props => [trip, this.currencies];
}

class StartPlanningInitial extends StartPlanningState {
  StartPlanningInitial(Trip? trip, List<Currency>? currencies) : super(trip, currencies);
}

class StartPlanningSuccessState extends StartPlanningState{
  final bool loading;

  StartPlanningSuccessState(Trip? trip, List<Currency>? currencies, this.loading) : super(trip, currencies);

  @override
  List<Object?> get props => [trip, currencies, loading];
}

class StartPlanningErrorState extends StartPlanningState{  
  final String error;

  StartPlanningErrorState(Trip? trip, List<Currency>? currencies, this.error) : super(trip, currencies);

  @override
  List<Object?> get props => [trip, currencies, error];
}

class StartPlanningCreatedState extends StartPlanningState{
  StartPlanningCreatedState(Trip trip, List<Currency>? currencies) : super(trip, currencies);

  @override
  List<Object?> get props => [trip, currencies];

}