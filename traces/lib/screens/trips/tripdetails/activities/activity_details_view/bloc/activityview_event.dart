part of 'activityview_bloc.dart';

@immutable
abstract class ActivityViewEvent {}

class GetActivityDetails extends ActivityViewEvent {
  final int activityId;

  GetActivityDetails(this.activityId);

  List<Object> get props => [activityId];
}
