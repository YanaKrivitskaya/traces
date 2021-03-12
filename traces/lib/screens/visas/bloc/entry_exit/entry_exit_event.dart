part of 'entry_exit_bloc.dart';

@immutable
abstract class EntryExitEvent {
  const EntryExitEvent();

  @override
  List<Object> get props => [];
}

class GetEntryDetails extends EntryExitEvent {
  final Visa visa;
  final EntryExit entry;

  GetEntryDetails(this.entry, this.visa);

  @override
  List<Object> get props => [entry, visa];
}

class SubmitEntry extends EntryExitEvent {
  final Visa visa;
  final EntryExit entry;

  SubmitEntry(this.entry, this.visa);

  @override
  List<Object> get props => [entry, visa];
}

class DeleteEntry extends EntryExitEvent {
  final Visa visa;
  final EntryExit entry;

  DeleteEntry(this.entry, this.visa);

  @override
  List<Object> get props => [entry, visa];
}

class EntryDateChanged extends EntryExitEvent {
  final DateTime entryDate;

  EntryDateChanged(this.entryDate);

  @override
  List<Object> get props => [entryDate];
}

class ExitDateChanged extends EntryExitEvent {
  final DateTime exitDate;

  ExitDateChanged(this.exitDate);

  @override
  List<Object> get props => [exitDate];
}
