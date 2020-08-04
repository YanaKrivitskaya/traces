part of 'visa_details_bloc.dart';

class VisaDetailsState {
  final Visa visa;
  final Settings settings;
  final UserCountries userCountries;
  final List<String> familyMembers;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const VisaDetailsState({
    @required this.visa,
    @required this.settings,
    @required this.userCountries,
    @required this.familyMembers,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory VisaDetailsState.empty(){
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMembers: null,
        isLoading: false,
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
        isSuccess: false,
        isFailure: false,
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
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.failure({Visa visa, Settings settings, UserCountries userCountries, List<String> members, String error}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
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
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return VisaDetailsState(
        visa: visa ?? this.visa,
        settings: settings ?? this.settings,
        userCountries: userCountries ?? this.userCountries,
        familyMembers: members ?? this.familyMembers,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  VisaDetailsState update({
    Visa visa,
    Settings settings,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        members: familyMembers,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }

}