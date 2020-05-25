part of 'family_bloc.dart';

class FamilyState {
  final Family familyMember;
  final String selectedGender;
  final bool isUsernameValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isNewMode;
  final bool isEditing;
  /*final bool isFailure;
  final String errorMessage;*/

  FamilyState({
    @required this.familyMember,
    @required this.selectedGender,
    @required this.isUsernameValid,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isNewMode,
    @required this.isEditing,
    /*@required this.isFailure,
    @required this.errorMessage*/
  });

  factory FamilyState.loading(){
    return FamilyState(
        familyMember: null,
        selectedGender: null,
        isUsernameValid: true,
        isLoading: true,
        isSuccess: false,
        isNewMode: false,
        isEditing: false
    );
  }

  factory FamilyState.success({Family family, String selectedGender, bool isNewMode, bool isEditing}){
    return FamilyState(
        familyMember: family,
        selectedGender: selectedGender,
        isUsernameValid: true,
        isLoading: false,
        isSuccess: true,
        isNewMode: isNewMode,
        isEditing: isEditing
    );
  }

  FamilyState copyWith({
    Family familyMember,
    String selectedGender,
    bool isUsernameValid,
    bool isLoading,
    bool isSuccess,
    bool isNewMode,
    bool isEditing
     /*bool isFailure,
    String errorMessage*/
  }){
    return FamilyState(
        familyMember: familyMember ?? this.familyMember,
        selectedGender: selectedGender ?? this.selectedGender,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isNewMode: isNewMode ?? this.isNewMode,
        isEditing: isEditing ?? this.isEditing
        /*isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage*/
    );
  }

  FamilyState update({
    Family familyMember,
    String selectedGender,
    bool isUsernameValid,
    bool isLoading,
    bool isSuccess,
    bool isNewMode,
    bool isEditing
    /*bool isFailure,
    String errorMessage*/
  }){
    return copyWith(
        familyMember: familyMember,
        selectedGender: selectedGender,
        isUsernameValid: isUsernameValid,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isNewMode: isNewMode,
        isEditing: isEditing
        /*isFailure: isFailure,
        errorMessage: errorMessage*/
    );
  }
}
