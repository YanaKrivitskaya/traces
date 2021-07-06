part of 'visa_details_bloc.dart';

@immutable
abstract class VisaDetailsEvent {
  const VisaDetailsEvent();

  List<Object?> get props => [];
}

class GetVisaDetails extends VisaDetailsEvent {
  final int visaId;

  GetVisaDetails(this.visaId);

  @override
  List<Object> get props => [visaId];
}

class UpdateVisaDetailsSuccess extends VisaDetailsEvent {
  final Visa visa;
  final List<EntryExit> entryExits;
  final VisaSettings settings;

  const UpdateVisaDetailsSuccess(this.visa, this.entryExits, this.settings);

  @override
  List<Object> get props => [visa, entryExits, settings];
}

class UpdateVisaDetailsEditing extends VisaDetailsEvent {
  final Visa? visa;
  final VisaSettings settings;
  final Group members;
  final UserSettings userSettings;

  const UpdateVisaDetailsEditing(this.visa, this.settings, this.members, this.userSettings);

  @override
  List<Object?> get props => [visa, settings, members, userSettings];
}

class NewVisaMode extends VisaDetailsEvent {}

class EditVisaClicked extends VisaDetailsEvent {
  final int visaId;

  EditVisaClicked(this.visaId);

  @override
  List<Object> get props => [visaId];
}

class DeleteVisaClicked extends VisaDetailsEvent {
  final int? visaId;

  DeleteVisaClicked(this.visaId);

  @override
  List<Object?> get props => [visaId];
}

class DateFromChanged extends VisaDetailsEvent {
  final DateTime dateFrom;

  DateFromChanged(this.dateFrom);

  @override
  List<Object> get props => [dateFrom];
}

class DateToChanged extends VisaDetailsEvent {
  final DateTime dateTo;

  DateToChanged(this.dateTo);

  @override
  List<Object> get props => [dateTo];
}

class VisaSubmitted extends VisaDetailsEvent {
  final Visa? visa;
  final bool isFormValid;

  VisaSubmitted(this.visa, this.isFormValid);

  @override
  List<Object?> get props => [visa, isFormValid];
}

class SaveVisaClicked extends VisaDetailsEvent {
  final Visa? visa;

  SaveVisaClicked(this.visa);

  @override
  List<Object?> get props => [visa];
}

class TabUpdatedClicked extends VisaDetailsEvent {
  final int index;

  TabUpdatedClicked(this.index);

  @override
  List<Object> get props => [index];
}
