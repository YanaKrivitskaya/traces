part of 'visa_details_bloc.dart';

class VisaDetailsState {
  Visa visa;
  final VisaSettings settings;
  final UserCountries userCountries;
  final List<String> familyMembers;
  final List<EntryExit> entryExits;
  final StateStatus status;
  final StateMode mode;
  final bool autovalidate;
  final String errorMessage;

  VisaDetailsState(
      {@required this.visa,
      @required this.settings,
      @required this.userCountries,
      @required this.familyMembers,
      @required this.entryExits,
      @required this.status,
      @required this.mode,
      this.autovalidate = false,
      this.errorMessage});

  factory VisaDetailsState.empty() {
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMembers: null,
        entryExits: null,
        status: StateStatus.Empty,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaDetailsState.loading() {
    return VisaDetailsState(
        visa: null,
        settings: null,
        userCountries: null,
        familyMembers: null,
        entryExits: null,
        status: StateStatus.Loading,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaDetailsState.editing(
      {Visa visa,
      VisaSettings settings,
      UserCountries userCountries,
      List<String> members,
      bool autovalidate}) {
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        status: StateStatus.Empty,
        mode: StateMode.Edit,
        autovalidate: autovalidate,
        errorMessage: "");
  }

  factory VisaDetailsState.success(
      {Visa visa,
      VisaSettings settings,
      UserCountries userCountries,
      List<String> members,
      List<EntryExit> entryExits}) {
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        entryExits: entryExits,
        status: StateStatus.Success,
        mode: StateMode.View,
        errorMessage: "");
  }

  factory VisaDetailsState.failure(
      {Visa visa,
      VisaSettings settings,
      UserCountries userCountries,
      List<String> members,
      List<EntryExit> entryExits,
      bool autovalidate,
      String error}) {
    return VisaDetailsState(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        familyMembers: members,
        entryExits: entryExits,
        status: StateStatus.Error,
        mode: StateMode.View,
        autovalidate: autovalidate,
        errorMessage: error);
  }

  VisaDetailsState copyWith(
      {final Visa visa,
      final VisaSettings settings,
      final UserCountries userCountries,
      final List<String> members,
      final List<EntryExit> entryExits,
      final StateStatus status,
      final StateMode mode,
      bool autovalidate,
      String errorMessage}) {
    return VisaDetailsState(
        visa: visa ?? this.visa,
        settings: settings ?? this.settings,
        userCountries: userCountries ?? this.userCountries,
        familyMembers: members ?? this.familyMembers,
        entryExits: entryExits ?? this.entryExits,
        status: status ?? this.status,
        mode: mode ?? this.mode,
        autovalidate: autovalidate ?? this.autovalidate,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  VisaDetailsState update(
      {Visa visa,
      VisaSettings settings,
      List<EntryExit> entryExits,
      StateStatus status,
      StateMode mode,
      bool autovalidate,
      String errorMessage}) {
    return copyWith(
        visa: visa,
        settings: settings,
        userCountries: userCountries,
        members: familyMembers,
        entryExits: entryExits,
        status: status,
        mode: mode,
        autovalidate: autovalidate,
        errorMessage: errorMessage);
  }
}
