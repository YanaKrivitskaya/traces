part of 'visa_details_bloc.dart';

class VisaDetailsState {
  final Visa visa;
  final Settings settings;
  final UserCountries userCountries;
  final Family familyMember;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const VisaDetailsState({
    @required this.visa,
    @required this.settings,
    @required this.userCountries,
    @required this.familyMember,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory VisaDetailsState.empty(){
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMember: null,
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
        familyMember: null,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.success({Visa visa, Settings settings, UserCountries userCountries, Family member}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMember: member,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory VisaDetailsState.failure({Visa visa, Settings settings, UserCountries userCountries, Family member, String error}){
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMember: member,
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
    final Family member,
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
        familyMember: member ?? this.familyMember,
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
        member: familyMember,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }

}