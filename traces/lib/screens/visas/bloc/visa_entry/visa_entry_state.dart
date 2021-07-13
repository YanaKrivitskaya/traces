part of 'visa_entry_bloc.dart';

class VisaEntryState {
  VisaEntry? visaEntry;
  final Visa? visa;
  final StateStatus status;
  final StateMode mode;
  final bool? entryDeleted;
  final CustomException? exception;

  VisaEntryState(
      {required this.visa,
      required this.visaEntry,
      required this.status,
      required this.mode,
      this.entryDeleted,
      this.exception});

  factory VisaEntryState.empty() {
    return VisaEntryState(
        visaEntry: null,
        visa: null,
        status: StateStatus.Empty,
        mode: StateMode.View,
        exception: null);
  }

  factory VisaEntryState.loading() {
    return VisaEntryState(
        visaEntry: null,
        visa: null,
        status: StateStatus.Loading,
        mode: StateMode.View,
        exception: null);
  }

  factory VisaEntryState.editing(
      {VisaEntry? entryExit, Visa? visa}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,
        status: StateStatus.Success,
        mode: StateMode.Edit,
        exception: null);
  }

  factory VisaEntryState.success(
      {VisaEntry? entryExit, Visa? visa, bool? entryDeleted}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,  
        status: StateStatus.Success,
        mode: StateMode.View,
        entryDeleted: entryDeleted,
        exception: null);
  }

  factory VisaEntryState.failure(
      {VisaEntry? entryExit, Visa? visa, CustomException? error}) {
    return VisaEntryState(
        visaEntry: entryExit,
        visa: visa,    
        status: StateStatus.Error,
        mode: StateMode.Edit,
        exception: error);
  }

  VisaEntryState copyWith(
      {final VisaEntry? visaEntry,
      final Visa? visa,  
      final StateStatus? status,
      final StateMode? mode,
      bool? entryDeleted,
      CustomException? error}) {
    return VisaEntryState(
        visa: visa ?? this.visa,     
        visaEntry: visaEntry ?? this.visaEntry,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        entryDeleted: entryDeleted ?? this.entryDeleted,
        exception: error ?? this.exception);
  }

  VisaEntryState update(
      {VisaEntry? visaEntry,
      Visa? visa,    
      StateStatus? status,
      StateMode? mode,
      bool? entryDeleted,
      CustomException? error}) {
    return copyWith(
        visaEntry: visaEntry,
        visa: visa,
        status: status,
        mode: mode,
        entryDeleted: entryDeleted,
        error: error);
  }
}