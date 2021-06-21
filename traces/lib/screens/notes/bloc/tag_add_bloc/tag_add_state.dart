import 'package:traces/screens/notes/model/tag.model.dart';
import 'package:meta/meta.dart';
import 'package:traces/shared/state_types.dart';

class TagAddState {
  final List<Tag> allTags;
  final List<Tag> filteredTags;
  final StateStatus status;
  final String errorMessage;


  const TagAddState({
    @required this.allTags,
    @required this.filteredTags,
    @required this.status,
    this.errorMessage});

  factory TagAddState.empty(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        status: StateStatus.Empty,
        errorMessage: ""
    );
  }

  factory TagAddState.loading(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        status: StateStatus.Loading,
        errorMessage: ""
    );
  }

  factory TagAddState.success({List<Tag> allTags, List<Tag> filteredTags}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        status: StateStatus.Success,
        errorMessage: ""
    );
  }

  factory TagAddState.failure({List<Tag> allTags, List<Tag> filteredTags, String error}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  TagAddState copyWith({
    List<Tag> allTags,
    List<Tag> filteredTags,
    StateStatus stateStatus,
    String errorMessage
  }){
    return TagAddState(
        allTags: allTags ?? this.allTags,
        filteredTags: filteredTags ?? this.filteredTags,
        status: stateStatus ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  TagAddState update({
    List<Tag> allTags,
    List<Tag> filteredTags,
    StateStatus stateStatus,
    String errorMessage
  }){
    return copyWith(
        allTags: allTags,
        filteredTags: filteredTags,
        stateStatus: stateStatus,
        errorMessage: errorMessage
    );
  }
}

class InitialTagAddState extends TagAddState {}
