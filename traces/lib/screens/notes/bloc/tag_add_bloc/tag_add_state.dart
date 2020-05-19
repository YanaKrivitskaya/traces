import 'package:traces/screens/notes/model/tag.dart';
import 'package:meta/meta.dart';

class TagAddState {
  final List<Tag> allTags;
  final List<Tag> filteredTags;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;


  const TagAddState({
    @required this.allTags,
    @required this.filteredTags,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory TagAddState.empty(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagAddState.loading(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagAddState.success({List<Tag> allTags, List<Tag> filteredTags}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagAddState.failure({List<Tag> allTags, List<Tag> filteredTags, String error}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: error
    );
  }

  TagAddState copyWith({
    List<Tag> allTags,
    List<Tag> filteredTags,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return TagAddState(
        allTags: allTags ?? this.allTags,
        filteredTags: filteredTags ?? this.filteredTags,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  TagAddState update({
    List<Tag> allTags,
    List<Tag> filteredTags,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        allTags: allTags,
        filteredTags: filteredTags,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }
}

class InitialTagAddState extends TagAddState {}
