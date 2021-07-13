part of 'visa_details_bloc.dart';

class VisaDetailsState {
  Visa? visa;
  final Group? familyGroup; 
  final StateStatus status;
  final StateMode mode;  
  final CustomException? exception;

  VisaDetailsState(
      {required this.visa,     
      required this.familyGroup,      
      required this.status,
      required this.mode,      
      this.exception});

  factory VisaDetailsState.empty() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,        
        status: StateStatus.Empty,
        mode: StateMode.View,
        exception: null,
      );
  }

  factory VisaDetailsState.loading() {
    return VisaDetailsState(
        visa: null,       
        familyGroup: null,       
        status: StateStatus.Loading,
        mode: StateMode.View,
        exception: null,
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
        exception: null,
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
        exception: null);
  }

  factory VisaDetailsState.failure(
      {Visa? visa,      
      Group? members,    
      bool? autovalidate,
      CustomException? error}) {
    return VisaDetailsState(
        visa: visa,        
        familyGroup: members,    
        status: StateStatus.Error,
        mode: StateMode.View,        
        exception: error);
  }

  VisaDetailsState copyWith(
      {final Visa? visa,      
      final Group? members,    
      final StateStatus? status,
      final StateMode? mode,      
      CustomException? errorMessage}) {
    return VisaDetailsState(
        visa: visa ?? this.visa,
        familyGroup: members ?? this.familyGroup,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        exception: errorMessage ?? this.exception       
    );
  }

  VisaDetailsState update(
      {Visa? visa,    
      StateStatus? status,
      StateMode? mode,      
      CustomException? errorMessage}) {
    return copyWith(
        visa: visa,        
        members: familyGroup,      
        status: status,
        mode: mode,        
        errorMessage: errorMessage
    );
  }
}
