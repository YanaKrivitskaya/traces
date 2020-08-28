part of 'visa_details_bloc.dart';

class VisaDetailsState {
  final Visa visa;
  final VisaSettings settings;
  final UserCountries userCountries;
  final List<String> familyMembers;
  final List<EntryExit> entryExits;
  final bool isLoading;
  final bool isEditing;
  final bool isSuccess;
  final bool isFailure;
  final bool autovalidate;
  final String errorMessage;

  const VisaDetailsState({
    @required this.visa,
    @required this.settings,
    @required this.userCountries,
    @required this.familyMembers,
    @required this.entryExits,
    @required this.isLoading,
    @required this.isEditing,
    @required this.isSuccess,
    @required this.isFailure,
    this.autovalidate = false,
    this.errorMessage});

  factory VisaDetailsState.empty(){
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMembers: null,
        entryExits: null,
        isLoading: false,
        isEditing: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.loading(){
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMembers: null,
        entryExits: null,
        isLoading: true,
        isEditing: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.editing({Visa visa, VisaSettings settings, UserCountries userCountries, List<String> members, bool autovalidate}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        isLoading: false,
        isEditing: true,
        isSuccess: false,
        isFailure: false,
        autovalidate: autovalidate,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.success({Visa visa, VisaSettings settings, UserCountries userCountries, List<String> members, List<EntryExit> entryExits}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        entryExits: entryExits,
        isLoading: false,
        isEditing: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.failure({
    Visa visa,
    VisaSettings settings,
    UserCountries userCountries,
    List<String> members,
    List<EntryExit> entryExits,
    bool autovalidate,
    String error
  }){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        entryExits: entryExits,
        isEditing: false,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        autovalidate: autovalidate,
        errorMessage: error
    );
  }

  VisaDetailsState copyWith({
    final Visa visa,
    final VisaSettings settings,
    final UserCountries userCountries,
    final List<String> members,
    final List<EntryExit> entryExits,
    bool searchEnabled,
    bool isLoading,
    bool isEditing,
    bool isSuccess,
    bool isFailure,
    bool autovalidate,
    String errorMessage
  }){
    return VisaDetailsState(
        visa: visa ?? this.visa,
        settings: settings ?? this.settings,
        userCountries: userCountries ?? this.userCountries,
        familyMembers: members ?? this.familyMembers,
        entryExits: entryExits ?? this.entryExits,
        isLoading: isLoading ?? this.isLoading,
        isEditing: isEditing ?? this.isEditing,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        autovalidate: autovalidate ?? this.autovalidate,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  VisaDetailsState update({
    Visa visa,
    VisaSettings settings,
    List<EntryExit> entryExits,
    bool isLoading,
    bool isEditing,
    bool isSuccess,
    bool isFailure,
    bool autovalidate,
    String errorMessage
  }){
    return copyWith(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        members: familyMembers,
        entryExits: entryExits,
        isLoading: isLoading,
        isEditing: isEditing,
        isSuccess: isSuccess,
        isFailure: isFailure,
        autovalidate: autovalidate,
        errorMessage: errorMessage
    );
  }

}