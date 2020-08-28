part of 'visa_details_bloc.dart';

@immutable
abstract class VisaDetailsEvent {
  const VisaDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetVisaDetails extends VisaDetailsEvent{
  final String visaId;

  GetVisaDetails(this.visaId);

  @override
  List<Object> get props => [visaId];
}

class UpdateVisaDetails extends VisaDetailsEvent {
  final Visa visa;
  final List<EntryExit> entryExists;
  final VisaSettings settings;

  const UpdateVisaDetails(this.visa, this.entryExists, this.settings);

  @override
  List<Object> get props => [visa, entryExists, settings];
}

class NewVisaMode extends VisaDetailsEvent{}

class EditModeClicked extends VisaDetailsEvent{
  final Visa visa;

  EditModeClicked(this.visa);

  @override
  List<Object> get props => [visa];
}

class DateFromChanged extends VisaDetailsEvent{
  final DateTime dateFrom;

  DateFromChanged(this.dateFrom);

  @override
  List<Object> get props => [dateFrom];
}

class DateToChanged extends VisaDetailsEvent{
  final DateTime dateTo;

  DateToChanged(this.dateTo);

  @override
  List<Object> get props => [dateTo];
}

class VisaSubmitted extends VisaDetailsEvent{
  final Visa visa;
  final bool isFormValid;

  VisaSubmitted(this.visa, this.isFormValid);

  @override
  List<Object> get props => [visa, isFormValid];
}

class SaveVisaClicked extends VisaDetailsEvent{
  final Visa visa;

  SaveVisaClicked(this.visa);

  @override
  List<Object> get props => [visa];
}