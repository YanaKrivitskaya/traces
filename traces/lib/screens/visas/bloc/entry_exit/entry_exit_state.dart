part of 'entry_exit_bloc.dart';

@immutable
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

class EditDetailsState extends EntryExitState {
  final VisaSettings settings;
  final EntryExit entry;
  final Visa visa;
  final bool isCountryValid;
  final bool isCityValid;

  EditDetailsState({this.settings, this.visa, this.entry, this.isCountryValid, this.isCityValid});

  @override
  List<Object> get props => [settings, entry, visa];

  @override
  String toString() => 'Edit details';
}