import 'package:meta/meta.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../models/tag.model.dart';

class TagAddState {
  final List<Tag>? allTags;
  final List<Tag>? filteredTags;
  final StateStatus status;
  final CustomException? errorMessage;


  const TagAddState({
    required this.allTags,
    required this.filteredTags,
    required this.status,
    this.errorMessage});

  factory TagAddState.empty(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        status: StateStatus.Empty,
        errorMessage: null
    );
  }

  factory TagAddState.loading(){
    return TagAddState(
        allTags: null,
        filteredTags: null,
        status: StateStatus.Loading,
        errorMessage: null
    );
  }

  factory TagAddState.success({List<Tag>? allTags, List<Tag>? filteredTags}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        status: StateStatus.Success,
        errorMessage:null
    );
  }

  factory TagAddState.failure({List<Tag>? allTags, List<Tag>? filteredTags, CustomException? error}){
    return TagAddState(
        allTags: allTags,
        filteredTags: filteredTags,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  TagAddState copyWith({
    List<Tag>? allTags,
    List<Tag>? filteredTags,
    StateStatus? stateStatus,
    CustomException? errorMessage
  }){
    return TagAddState(
        allTags: allTags ?? this.allTags,
        filteredTags: filteredTags ?? this.filteredTags,
        status: stateStatus ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  TagAddState update({
    List<Tag>? allTags,
    List<Tag>? filteredTags,
    StateStatus? stateStatus,
    CustomException? errorMessage
  }){
    return copyWith(
        allTags: allTags,
        filteredTags: filteredTags,
        stateStatus: stateStatus,
        errorMessage: errorMessage
    );
  }
}

class InitialTagAddState extends TagAddState {
  InitialTagAddState() : super(filteredTags: null, allTags: null, status: StateStatus.Empty);
}
