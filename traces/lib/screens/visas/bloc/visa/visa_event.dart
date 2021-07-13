part of 'visa_bloc.dart';

@immutable
abstract class VisaEvent extends Equatable {
  const VisaEvent();

  @override
  List<Object> get props => [];
}

class GetAllVisas extends VisaEvent {}