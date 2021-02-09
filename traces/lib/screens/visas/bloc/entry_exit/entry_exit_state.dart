part of 'entry_exit_bloc.dart';


class EntryExitState{
  final EntryExit entryExit;
  final Visa visa;
  final VisaSettings settings;
  final StateStatus status;
  final StateMode mode;
  final String errorMessage;

  EntryExitState({
    @required this.visa,
    @required this.entryExit,
    @required this.settings,
    @required this.status,
    @required this.mode,
    this.errorMessage
  });

  factory EntryExitState.empty(){
    return EntryExitState(
      entryExit: null, 
      visa: null,
      settings: null,
      status: StateStatus.Empty,
      mode: StateMode.View,
      errorMessage: "");
  }

  factory EntryExitState.loading(){
    return EntryExitState(
      entryExit: null, 
      visa: null,
      settings: null,
      status: StateStatus.Loading,
      mode: StateMode.View,
      errorMessage: "");
  }

  factory EntryExitState.editing({EntryExit entryExit, Visa visa, VisaSettings settings}){
    return EntryExitState(
      entryExit: entryExit, 
      visa: visa,
      settings: settings,
      status: StateStatus.Success,
      mode: StateMode.Edit,
      errorMessage: "");
  }

  factory EntryExitState.success({EntryExit entryExit, Visa visa, VisaSettings settings}){
    return EntryExitState(
      entryExit: entryExit, 
      visa: visa,
      settings: settings,
      status: StateStatus.Success,
      mode: StateMode.View,
      errorMessage: "");
  }

  factory EntryExitState.failure({EntryExit entryExit, Visa visa, VisaSettings settings, String error}){
    return EntryExitState(
      entryExit: entryExit, 
      visa: visa,
      settings: settings,
      status: StateStatus.Error,
      mode: StateMode.Edit,
      errorMessage: error);
  }

  EntryExitState copyWith({
    final EntryExit entryExit,
    final Visa visa,
    final VisaSettings settings,
    final StateStatus status,
    final StateMode mode,
    String error
  }){
    return EntryExitState(
      visa: visa ?? this.visa, 
      settings: settings ?? this.settings,
      entryExit: entryExit ?? this.entryExit, 
      status: status ?? this.status,
      mode: mode ?? this.mode,
      errorMessage: error ?? this.errorMessage
      );
  }

  EntryExitState update({
    EntryExit entryExit,
    Visa visa,
    VisaSettings settings,
    StateStatus status,
    StateMode mode,
    String error
  }){
    return copyWith(
      entryExit: entryExit, 
      visa: visa,
      settings: settings,
      status: status, 
      mode: mode,
      error: error
      );
  }
  
}

/*@immutable
abstract class EntryExitState {
  /*final VisaSettings settings;
  final EntryExit entry;
  final Visa visa;*/

  EntryExitState(/*this.settings, this.visa, this.entry*/);
}

class InitialEntryExitState extends EntryExitState {
  @override
  String toString() => 'Initial';
  //InitialEntryExitState(/*VisaSettings settings, EntryExit entry, Visa visa) : super(settings, visa, entry);
}

class LoadingEntryDetailsState extends EntryExitState {
  @override
  String toString() => 'Loading';
  //LoadingDetailsState(VisaSettings settings, EntryExit entry, Visa visa);/* : super(settings, visa, entry);*/
}

class SuccessEntryDetailsState extends EntryExitState {
  final Visa visa;

  SuccessEntryDetailsState({this.visa});

  @override
  List<Object> get props => [visa];

  @override
  String toString() => 'Success';
  //LoadingDetailsState(VisaSettings settings, EntryExit entry, Visa visa); : super(settings, visa, entry);*/
}

class EditDetailsState extends EntryExitState {
  final VisaSettings settings;
  final EntryExit entry;
  final Visa visa;
  final bool isEntryEdit;
  final bool isExitEdit;

  EditDetailsState(
      {this.settings,
      this.visa,
      this.entry,
      this.isEntryEdit,
      this.isExitEdit});

  @override
  List<Object> get props => [settings, entry, visa, isEntryEdit, isExitEdit];

  @override
  String toString() => 'Edit details';
}*/
