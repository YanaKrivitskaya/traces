part of 'visa_details_bloc.dart';

class VisaDetailsState {
  final Visa visa;
  final Settings settings;
  final UserCountries userCountries;
  final List<String> familyMembers;
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
        isLoading: true,
        isEditing: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.editing({Visa visa, Settings settings, UserCountries userCountries, List<String> members, bool autovalidate}){
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

  factory VisaDetailsState.success({Visa visa, Settings settings, UserCountries userCountries, List<String> members}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        isLoading: false,
        isEditing: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.failure({
    Visa visa,
    Settings settings,
    UserCountries userCountries,
    List<String> members,
    bool autovalidate,
    String error
  }){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
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
    final Settings settings,
    final UserCountries userCountries,
    final List<String> members,
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
    Settings settings,
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
        isLoading: isLoading,
        isEditing: isEditing,
        isSuccess: isSuccess,
        isFailure: isFailure,
        autovalidate: autovalidate,
        errorMessage: errorMessage
    );
  }

}