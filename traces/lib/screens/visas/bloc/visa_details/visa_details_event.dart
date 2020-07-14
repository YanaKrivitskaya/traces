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

class NewVisaMode extends VisaDetailsEvent{}

class EditModeClicked extends VisaDetailsEvent{
  final Visa visa;

  EditModeClicked(this.visa);

  @override
  List<Object> get props => [visa];
}

class SaveNoteClicked extends VisaDetailsEvent{
  final Visa visa;

  SaveNoteClicked(this.visa);

  @override
  List<Object> get props => [visa];
}