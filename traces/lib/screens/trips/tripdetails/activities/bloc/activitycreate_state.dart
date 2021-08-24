part of 'activitycreate_bloc.dart';

abstract class ActivityCreateState {
  Activity? activity;

  ActivityCreateState(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityCreateInitial extends ActivityCreateState {
  ActivityCreateInitial(Activity? activity) : super(activity);
}

class ActivityCreateEdit extends ActivityCreateState {
  final bool loading;

  ActivityCreateEdit(Activity? activity, this.loading) : super(activity);

  @override
  List<Object?> get props => [activity, loading];
}

class ActivityCreateError extends ActivityCreateState {
  final String error;

  ActivityCreateError(Activity? activity, this.error) : super(activity);

  @override
  List<Object?> get props => [activity, error];
}

class ActivityCreateSuccess extends ActivityCreateState {

  ActivityCreateSuccess(Activity? activity) : super(activity);

  @override
  List<Object?> get props => [activity];
}
