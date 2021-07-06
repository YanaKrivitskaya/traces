part of 'visa_entry_bloc.dart';

@immutable
abstract class VisaEntryEvent {
  const VisaEntryEvent();

  List<Object?> get props => [];
}

class GetEntryDetails extends VisaEntryEvent {
  final Visa? visa;
  final VisaEntry? entry;

  GetEntryDetails(this.entry, this.visa);

  @override
  List<Object?> get props => [entry, visa];
}

class SubmitEntry extends VisaEntryEvent {
  final Visa? visa;
  VisaEntry? entry;

  SubmitEntry(this.entry, this.visa);

  @override
  List<Object?> get props => [entry, visa];
}

class DeleteEntry extends VisaEntryEvent {
  final Visa? visa;
  final VisaEntry? entry;

  DeleteEntry(this.entry, this.visa);

  @override
  List<Object?> get props => [entry, visa];
}

class EntryDateChanged extends VisaEntryEvent {
  final DateTime entryDate;

  EntryDateChanged(this.entryDate);

  @override
  List<Object> get props => [entryDate];
}

class ExitDateChanged extends VisaEntryEvent {
  final DateTime exitDate;

  ExitDateChanged(this.exitDate);

  @override
  List<Object> get props => [exitDate];
}
