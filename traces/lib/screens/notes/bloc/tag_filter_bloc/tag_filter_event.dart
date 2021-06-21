import 'package:equatable/equatable.dart';

import '../../models/tag.model.dart';

abstract class TagFilterEvent extends Equatable {
  const TagFilterEvent();

  @override
  List<Object> get props => [];
}

class GetTags extends TagFilterEvent{}

class TagChecked extends TagFilterEvent {
  final Tag tag;
  final bool checked;

  const TagChecked(this.tag, this.checked);

  @override
  List<Object> get props => [tag, checked];
}

class AllTagsChecked extends TagFilterEvent {
  final bool checked;

  const AllTagsChecked(this.checked);

  @override
  List<Object> get props => [checked];
}

class NoTagsChecked extends TagFilterEvent {
  final bool checked;

  const NoTagsChecked(this.checked);

  @override
  List<Object> get props => [checked];
}

class UpdateTagsList extends TagFilterEvent {
  final List<Tag> allTags;
  final List<Tag> selectedTags;
  final bool noTagsChecked;
  final bool allTagsChecked;
  final bool allTagsUnChecked;

  const UpdateTagsList(this.allTags, {this.selectedTags, this.noTagsChecked, this.allTagsChecked, this.allTagsUnChecked});

  @override
  List<Object> get props => [allTags, selectedTags, noTagsChecked, allTagsChecked, allTagsUnChecked];
}
