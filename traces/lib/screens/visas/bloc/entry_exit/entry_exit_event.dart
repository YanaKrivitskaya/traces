part of 'entry_exit_bloc.dart';

@immutable
abstract class EntryExitEvent {
  const EntryExitEvent();

   @override
  List<Object> get props => [];
}

class GetEntryDetails extends EntryExitEvent{
  final Visa visa;
  final EntryExit entry;
  final bool isEntryEdit;
  final bool isExitEdit;

  GetEntryDetails(this.entry, this.visa, this.isEntryEdit, this.isExitEdit);

  @override
  List<Object> get props => [entry, visa, isEntryEdit, isExitEdit];
}

class SubmitEntry extends EntryExitEvent{
  final Visa visa;
  final EntryExit entry;

  SubmitEntry(this.entry, this.visa);

  @override
  List<Object> get props => [entry, visa];
}

class EntryDateChanged extends EntryExitEvent{  
  final DateTime entryDate;

  EntryDateChanged(this.entryDate);

  @override
  List<Object> get props => [entryDate];
}

class ExitDateChanged extends EntryExitEvent{  
  final DateTime exitDate;

  ExitDateChanged(this.exitDate);

  @override
  List<Object> get props => [exitDate];
}

/*class CityChanged extends EntryExitEvent{
  final String city;

  CityChanged({@required this.city});

  @override
  List<Object> get props => [city];
}*/
