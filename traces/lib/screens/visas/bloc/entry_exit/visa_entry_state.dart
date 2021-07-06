part of 'visa_entry_bloc.dart';

class VisaEntryState {
  VisaEntry? visaEntry;
  final Visa? visa;
  final StateStatus status;
  final StateMode mode;
  final String? errorMessage;

  VisaEntryState(
      {required this.visa,
      required this.visaEntry,
      required this.status,
      required this.mode,
      this.errorMessage});

  factory VisaEntryState.empty() {
    return VisaEntryState(
        visaEntry: null,
        visa: null,
        status: StateStatus.Empty,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaEntryState.loading() {
    return VisaEntryState(
        visaEntry: null,
        visa: null,
        status: StateStatus.Loading,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaEntryState.editing(
      {VisaEntry? entryExit, Visa? visa}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,
        status: StateStatus.Success,
        mode: StateMode.Edit,
        errorMessage: "");
  }

  factory VisaEntryState.success(
      {VisaEntry? entryExit, Visa? visa}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,  
        status: StateStatus.Success,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaEntryState.failure(
      {VisaEntry? entryExit, Visa? visa, String? error}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,    
        status: StateStatus.Error,
        mode: StateMode.Edit,
        errorMessage: error);
  }

  VisaEntryState copyWith(
      {final VisaEntry? visaEntry,
      final Visa? visa,  
      final StateStatus? status,
      final StateMode? mode,
      String? error}) {
    return VisaEntryState(
        visa: visa ?? this.visa,     
        visaEntry: visaEntry ?? this.visaEntry,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        errorMessage: error ?? this.errorMessage);
  }

  VisaEntryState update(
      {VisaEntry? visaEntry,
      Visa? visa,    
      StateStatus? status,
      StateMode? mode,
      String? error}) {
    return copyWith(
        visaEntry: visaEntry,
        visa: visa,
        status: status,
        mode: mode,
        error: error);
  }
}