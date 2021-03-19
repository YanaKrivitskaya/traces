part of 'visa_bloc.dart';

@immutable
abstract class VisaEvent extends Equatable {
  const VisaEvent();

  @override
  List<Object> get props => [];
}

class GetAllVisas extends VisaEvent {}

class UpdateVisasList extends VisaEvent {
  final List<Visa> allVisas;

  const UpdateVisasList(this.allVisas);

  @override
  List<Object> get props => [allVisas];
}

class VisaTabUpdated extends VisaEvent {
  final VisaTab activeTab;

  const VisaTabUpdated(this.activeTab);

  @override
  List<Object> get props => [activeTab];
}
