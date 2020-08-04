part of 'visa_bloc.dart';

class VisaState {
  final List<Visa> allVisas;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const VisaState({
    @required this.allVisas,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory VisaState.empty(){
    return VisaState(
        allVisas: null,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaState.loading(){
    return VisaState(
        allVisas: null,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaState.success({List<Visa> allVisas}){
    return VisaState(
        allVisas: allVisas,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaState.failure({List<Visa> allVisas, String error}){
    return VisaState(
        allVisas: allVisas,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: error
    );
  }

  VisaState copyWith({
    final List<Visa> allVisas,
    bool searchEnabled,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return VisaState(
        allVisas: allVisas ?? this.allVisas,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  VisaState update({
    List<Visa> allVisas,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        allVisas: allVisas,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }

}
