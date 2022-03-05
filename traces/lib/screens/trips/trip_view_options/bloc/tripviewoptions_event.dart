part of 'tripviewoptions_bloc.dart';

@immutable
abstract class TripViewOptionsEvent{
  const TripViewOptionsEvent();
}

class ViewOptionUpdated extends TripViewOptionsEvent{
  final int option;

  const ViewOptionUpdated(this.option);
}