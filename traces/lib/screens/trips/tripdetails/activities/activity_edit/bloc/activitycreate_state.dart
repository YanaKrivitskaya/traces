part of 'activitycreate_bloc.dart';

abstract class ActivityCreateState {
  Activity? activity;
  List<ActivityCategory>? categories;

  ActivityCreateState(this.activity, this.categories);

  @override
  List<Object?> get props => [activity, categories];
}

class ActivityCreateInitial extends ActivityCreateState {
  ActivityCreateInitial(Activity? activity, List<ActivityCategory>? categories) : super(activity, categories);
}

class ActivityCreateEdit extends ActivityCreateState {
  final bool loading;

  ActivityCreateEdit(Activity? activity, List<ActivityCategory>? categories, this.loading) : super(activity, categories);

  @override
  List<Object?> get props => [activity, loading];
}

class ActivityCreateError extends ActivityCreateState {
  final String error;

  ActivityCreateError(Activity? activity, List<ActivityCategory>? categories, this.error) : super(activity, categories);

  @override
  List<Object?> get props => [activity, error];
}

class ActivityCreateSuccess extends ActivityCreateState {

  ActivityCreateSuccess(Activity? activity, List<ActivityCategory>? categories) : super(activity, categories);

  @override
  List<Object?> get props => [activity];
}
