part of 'entry_exit_bloc.dart';

class EntryExitState {
  final EntryExit? entryExit;
  final UserSettings? userSettings;
  final Visa? visa;
  final VisaSettings? settings;
  final StateStatus status;
  final StateMode mode;
  final String? errorMessage;

  EntryExitState(
      {required this.visa,
      required this.entryExit,
      required this.settings,
      required this.userSettings,
      required this.status,
      required this.mode,
      this.errorMessage});

  factory EntryExitState.empty() {
    return EntryExitState(
        entryExit: null,
        visa: null,
        settings: null,
        userSettings: null,
        status: StateStatus.Empty,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory EntryExitState.loading() {
    return EntryExitState(
        entryExit: null,
        visa: null,
        settings: null,
        userSettings: null,
        status: StateStatus.Loading,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory EntryExitState.editing(
      {EntryExit? entryExit, Visa? visa, VisaSettings? settings, UserSettings? userSettings}) {
    return EntryExitState(
        entryExit: entryExit,
        visa: visa,
        settings: settings,
        userSettings: userSettings,
        status: StateStatus.Success,
        mode: StateMode.Edit,
        errorMessage: "");
  }

  factory EntryExitState.success(
      {EntryExit? entryExit, Visa? visa, VisaSettings? settings, UserSettings? userSettings}) {
    return EntryExitState(
        entryExit: entryExit,
        visa: visa,
        settings: settings,
        userSettings: userSettings,
        status: StateStatus.Success,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory EntryExitState.failure(
      {EntryExit? entryExit, Visa? visa, VisaSettings? settings, UserSettings? userSettings, String? error}) {
    return EntryExitState(
        entryExit: entryExit,
        visa: visa,
        settings: settings,
        userSettings: userSettings,
        status: StateStatus.Error,
        mode: StateMode.Edit,
        errorMessage: error);
  }

  EntryExitState copyWith(
      {final EntryExit? entryExit,
      final Visa? visa,
      final VisaSettings? settings,
      final UserSettings? userSettings,
      final StateStatus? status,
      final StateMode? mode,
      String? error}) {
    return EntryExitState(
        visa: visa ?? this.visa,
        settings: settings ?? this.settings,
        userSettings: userSettings ?? this.userSettings,
        entryExit: entryExit ?? this.entryExit,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        errorMessage: error ?? this.errorMessage);
  }

  EntryExitState update(
      {EntryExit? entryExit,
      Visa? visa,
      VisaSettings? settings,
      UserSettings? userSettings,
      StateStatus? status,
      StateMode? mode,
      String? error}) {
    return copyWith(
        entryExit: entryExit,
        visa: visa,
        userSettings: userSettings,
        settings: settings,
        status: status,
        mode: mode,
        error: error);
  }
}