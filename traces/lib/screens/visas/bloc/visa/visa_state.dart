part of 'visa_bloc.dart';

class VisaState {
  final List<Visa> allVisas;
  final StateStatus status;
  final String errorMessage;

  const VisaState(
      {@required this.allVisas, @required this.status, this.errorMessage});

  factory VisaState.empty() {
    return VisaState(
        allVisas: null, status: StateStatus.Empty, errorMessage: "");
  }

  factory VisaState.loading() {
    return VisaState(
        allVisas: null, status: StateStatus.Loading, errorMessage: "");
  }

  factory VisaState.success({List<Visa> allVisas}) {
    return VisaState(
        allVisas: allVisas, status: StateStatus.Success, errorMessage: "");
  }

  factory VisaState.failure({List<Visa> allVisas, String error}) {
    return VisaState(
        allVisas: allVisas, status: StateStatus.Error, errorMessage: error);
  }

  VisaState copyWith(
      {final List<Visa> allVisas,
      bool searchEnabled,
      StateStatus status,
      String errorMessage}) {
    return VisaState(
        allVisas: allVisas ?? this.allVisas,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  VisaState update(
      {List<Visa> allVisas, StateStatus status, String errorMessage}) {
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
