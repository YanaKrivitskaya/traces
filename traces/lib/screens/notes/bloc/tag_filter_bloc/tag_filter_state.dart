
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../models/tag.model.dart';


class TagFilterState{
  final List<Tag>? allTags;
  final List<Tag>? selectedTags;
  final bool? noTagsChecked;
  final bool? allTagsChecked;
  final bool? allUnChecked;
  final StateStatus status;
  final CustomException? errorMessage;

  const TagFilterState({
    required this.allTags,
    required this.selectedTags,
    required this.noTagsChecked,
    required this.allTagsChecked,
    required this.allUnChecked,
    required this.status,
    this.errorMessage});

  factory TagFilterState.empty(){
    return TagFilterState(
        allTags: null,
        selectedTags: null,
        noTagsChecked: true,
        allTagsChecked: true,
        allUnChecked: false,
        status: StateStatus.Empty,
        errorMessage: null
    );
  }

  factory TagFilterState.loading(){
    return TagFilterState(
        allTags: null,
        selectedTags: null,
        noTagsChecked: true,
        allTagsChecked: true,
        allUnChecked: false,
        status: StateStatus.Loading,
        errorMessage: null
    );
  }

  factory TagFilterState.success({List<Tag>? allTags, List<Tag>? selectedTags, bool? noTagsChecked, bool? allTagsChecked, bool? allUnchecked}){
    return TagFilterState(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnchecked,
        status: StateStatus.Success,
        errorMessage: null
    );
  }

  factory TagFilterState.failure({List<Tag>? allTags, List<Tag>? selectedTags, bool? noTagsChecked, bool? allTagsChecked, CustomException? error, bool? allUnchecked}){
    return TagFilterState(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnchecked,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  TagFilterState copyWith({
    List<Tag>? allTags,
    List<Tag>? selectedTags,
    bool? noTagsChecked,
    bool? allTagsChecked,
    bool? allUnChecked,
    StateStatus? stateStatus,
    CustomException? errorMessage
  }){
    return TagFilterState(
        allTags: allTags ?? this.allTags,
        selectedTags: selectedTags ?? this.selectedTags,
        noTagsChecked: noTagsChecked ?? this.noTagsChecked,
        allTagsChecked: allTagsChecked ?? this.allTagsChecked,
        allUnChecked: allUnChecked ?? this.allUnChecked,
        status: stateStatus ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  TagFilterState update({
    List<Tag>? allTags,
    List<Tag>? selectedTags,
    bool? noTagsChecked,
    bool? allTagsChecked,
    bool? allUnChecked,
    StateStatus? stateStatus,
    CustomException? errorMessage
  }){
    return copyWith(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnChecked,
        stateStatus: stateStatus,
        errorMessage: errorMessage
    );
  }
}
