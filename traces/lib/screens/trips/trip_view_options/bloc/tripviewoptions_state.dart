part of 'tripviewoptions_bloc.dart';

abstract class TripViewOptionsState{
  final int? activeOption;

  const TripViewOptionsState(this.activeOption);

  @override
  List<Object?> get props => [activeOption];
}

class TripViewOptionSelectedState extends TripViewOptionsState {
  TripViewOptionSelectedState(int? activeOption) : super(activeOption);
}