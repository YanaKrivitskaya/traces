part of 'visa_details_bloc.dart';

class VisaDetailsState {
  Visa? visa;
  final Group? familyGroup; 
  final StateStatus status;
  final StateMode mode;  
  final String? errorMessage;

  VisaDetailsState(
      {required this.visa,     
      required this.familyGroup,      
      required this.status,
      required this.mode,      
      this.errorMessage});

  factory VisaDetailsState.empty() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,        
        status: StateStatus.Empty,
        mode: StateMode.View,
        errorMessage: "",
      );
  }

  factory VisaDetailsState.loading() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,       
        status: StateStatus.Loading,
        mode: StateMode.View,
        errorMessage: "",
      );
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
        errorMessage: "",
      );
  }

  factory VisaDetailsState.success(
      {Visa? visa,
      int? activeTab,
      VisaSettings? settings,      
      Group? members}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,       
        status: StateStatus.Success,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaDetailsState.failure(
      {Visa? visa,      
      Group? members,    
      bool? autovalidate,
      String? error}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,    
        status: StateStatus.Error,
        mode: StateMode.View,        
        errorMessage: error);
  }

  VisaDetailsState copyWith(
      {final Visa? visa,      
      final Group? members,    
      final StateStatus? status,
      final StateMode? mode,      
      String? errorMessage}) {
    return VisaDetailsState(
        visa: visa ?? this.visa,
        familyGroup: members ?? this.familyGroup,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        errorMessage: errorMessage ?? this.errorMessage       
    );
  }

  VisaDetailsState update(
      {Visa? visa,    
      StateStatus? status,
      StateMode? mode,      
      String? errorMessage}) {
    return copyWith(
        visa: visa,        
        members: familyGroup,      
        status: status,
        mode: mode,        
        errorMessage: errorMessage
    );
  }
}
