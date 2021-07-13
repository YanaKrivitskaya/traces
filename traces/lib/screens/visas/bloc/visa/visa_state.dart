part of 'visa_bloc.dart';

class VisaState {
  final List<Visa>? allVisas;
  final StateStatus status;
  final CustomException? errorMessage;

  const VisaState(
      {required this.allVisas, required this.status, this.errorMessage});

  factory VisaState.empty() {
    return VisaState(
        allVisas: null, status: StateStatus.Empty, errorMessage: null);
  }

  factory VisaState.loading() {
    return VisaState(
        allVisas: null, status: StateStatus.Loading, errorMessage: null);
  }

  factory VisaState.success({List<Visa>? allVisas}) {
    return VisaState(
        allVisas: allVisas, status: StateStatus.Success, errorMessage: null);
  }

  factory VisaState.failure({List<Visa>? allVisas, CustomException? error}) {
    return VisaState(
        allVisas: allVisas, status: StateStatus.Error, errorMessage: error);
  }

  VisaState copyWith(
      {final List<Visa>? allVisas,
      bool? searchEnabled,
      StateStatus? status,
      CustomException? errorMessage}) {
    return VisaState(
        allVisas: allVisas ?? this.allVisas,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  VisaState update(
      {List<Visa>? allVisas, StateStatus? status, CustomException? errorMessage}) {
    return copyWith(
        allVisas: allVisas, status: status, errorMessage: errorMessage);
  }

  @override
  String toString() {
    return '''VisaState{
      allVisas: $allVisas,
      status: $status,      
      errorMessage: $errorMessage      
    }''';
  }
}
