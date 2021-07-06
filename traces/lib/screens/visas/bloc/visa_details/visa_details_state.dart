part of 'visa_details_bloc.dart';

class VisaDetailsState {
  Visa? visa;
  final Group? familyGroup;
  final List<EntryExit>? entryExits;
  final StateStatus status;
  final StateMode mode;  
  final String? errorMessage;
  final int? activeTab;

  VisaDetailsState(
      {required this.visa,     
      required this.familyGroup,
      required this.entryExits,
      required this.status,
      required this.mode,      
      this.errorMessage, this.activeTab});

  factory VisaDetailsState.empty() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,
        entryExits: null,
        status: StateStatus.Empty,
        mode: StateMode.View,
        errorMessage: "",
        activeTab: 0);
  }

  factory VisaDetailsState.loading() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,
        entryExits: null,
        status: StateStatus.Loading,
        mode: StateMode.View,
        errorMessage: "",
        activeTab: 0);
  }

  factory VisaDetailsState.editing(
      {Visa? visa,     
      Group? members,
      bool? autovalidate}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,
        status: StateStatus.Empty,
        mode: StateMode.Edit,        
        errorMessage: "", entryExits: null,
        activeTab: 0);
  }

  factory VisaDetailsState.success(
      {Visa? visa,
      VisaSettings? settings,
      UserSettings? userSettings,
      Group? members,
      List<EntryExit>? entryExits}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,
        entryExits: entryExits,
        status: StateStatus.Success,
        mode: StateMode.View,
        errorMessage: "", activeTab: 0);
  }

  factory VisaDetailsState.failure(
      {Visa? visa,      
      Group? members,
      List<EntryExit>? entryExits,
      bool? autovalidate,
      String? error}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,
        entryExits: entryExits,
        status: StateStatus.Error,
        mode: StateMode.View,        
        errorMessage: error, activeTab: 0);
  }

  VisaDetailsState copyWith(
      {final Visa? visa,      
      final Group? members,
      final List<EntryExit>? entryExits,
      final StateStatus? status,
      final StateMode? mode,      
      String? errorMessage, int? activeTab}) {
    return VisaDetailsState(
        visa: visa ?? this.visa,        
        familyGroup: members ?? this.familyGroup,
        entryExits: entryExits ?? this.entryExits,
        status: status ?? this.status,
        mode: mode ?? this.mode,       
        errorMessage: errorMessage ?? this.errorMessage,
        activeTab: activeTab ?? this.activeTab
    );
  }

  VisaDetailsState update(
      {Visa? visa,      
      List<EntryExit>? entryExits,
      StateStatus? status,
      StateMode? mode,      
      String? errorMessage, int? activeTab}) {
    return copyWith(
        visa: visa,        
        members: familyGroup,
        entryExits: entryExits,
        status: status,
        mode: mode,        
        errorMessage: errorMessage, 
        activeTab: activeTab
    );
  }
}
