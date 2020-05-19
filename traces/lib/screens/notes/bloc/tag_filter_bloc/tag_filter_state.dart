import 'package:traces/screens/notes/model/tag.dart';
import 'package:meta/meta.dart';

class TagFilterState{
  final List<Tag> allTags;
  final List<Tag> selectedTags;
  final bool noTagsChecked;
  final bool allTagsChecked;
  final bool allUnChecked;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const TagFilterState({
    @required this.allTags,
    @required this.selectedTags,
    @required this.noTagsChecked,
    @required this.allTagsChecked,
    @required this.allUnChecked,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory TagFilterState.empty(){
    return TagFilterState(
        allTags: null,
        selectedTags: null,
        noTagsChecked: true,
        allTagsChecked: true,
        allUnChecked: false,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagFilterState.loading(){
    return TagFilterState(
        allTags: null,
        selectedTags: null,
        noTagsChecked: true,
        allTagsChecked: true,
        allUnChecked: false,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagFilterState.success({List<Tag> allTags, List<Tag> selectedTags, bool noTagsChecked, bool allTagsChecked, bool allUnchecked}){
    return TagFilterState(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnchecked,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory TagFilterState.failure({List<Tag> allTags, List<Tag> selectedTags, bool noTagsChecked, bool allTagsChecked, String error, bool allUnchecked}){
    return TagFilterState(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnchecked,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: error
    );
  }

  TagFilterState copyWith({
    List<Tag> allTags,
    List<Tag> selectedTags,
    bool noTagsChecked,
    bool allTagsChecked,
    bool allUnChecked,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return TagFilterState(
        allTags: allTags ?? this.allTags,
        selectedTags: selectedTags ?? this.selectedTags,
        noTagsChecked: noTagsChecked ?? this.noTagsChecked,
        allTagsChecked: allTagsChecked ?? this.allTagsChecked,
        allUnChecked: allUnChecked ?? this.allUnChecked,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  TagFilterState update({
    List<Tag> allTags,
    List<Tag> selectedTags,
    bool noTagsChecked,
    bool allTagsChecked,
    bool allUnChecked,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        allTags: allTags,
        selectedTags: selectedTags,
        noTagsChecked: noTagsChecked,
        allTagsChecked: allTagsChecked,
        allUnChecked: allUnChecked,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }
}
