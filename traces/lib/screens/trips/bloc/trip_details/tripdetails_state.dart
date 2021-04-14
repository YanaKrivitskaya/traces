part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsState extends Equatable{
  const TripDetailsState();

  @override
  List<Object> get props => [];
}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsSuccessState extends TripDetailsState{
  Trip trip;

  TripDetailsSuccessState(this.trip);

  @override
  List<Object> get props => [trip];

}