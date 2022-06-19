part of 'activityview_bloc.dart';

abstract class ActivityViewState {
  Activity? activity;

  ActivityViewState(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityViewInitial extends ActivityViewState {
  ActivityViewInitial(Activity? activity) : super(activity);
}

class ActivityViewLoading extends ActivityViewState {
  ActivityViewLoading(Activity? activity) : super(activity);
}

class ActivityViewSuccess extends ActivityViewState {

  ActivityViewSuccess(Activity? activity) : super(activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityViewError extends ActivityViewState {
  final String error;

  ActivityViewError(Activity? activity, this.error) : super(activity);

  @override
  List<Object?> get props => [activity, error];
}
