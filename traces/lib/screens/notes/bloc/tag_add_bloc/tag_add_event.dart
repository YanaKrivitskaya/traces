import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/create_tag.model.dart';
import '../../models/tag.model.dart';

abstract class TagAddEvent extends Equatable {
  const TagAddEvent();

  @override
  List<Object?> get props => [];
}

class GetTags extends TagAddEvent{}

class AddTag extends TagAddEvent{
  final CreateTagModel tag;

  const AddTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class UpdateNoteTag extends TagAddEvent {
  final int? noteId;
  final int? tagId;
  final bool? isChecked;

  const UpdateNoteTag(this.noteId, this.tagId, this.isChecked);

  @override
  List<Object?> get props => [noteId, tagId, isChecked];
}

class TagChanged extends TagAddEvent{
  final String? tagName;

  const TagChanged({required this.tagName});

  @override
  List<Object?> get props => [tagName];
}

class UpdateTagsList extends TagAddEvent {
  final List<Tag>? allTags;
  final List<Tag>? filteredTags;

  const UpdateTagsList(this.allTags, this.filteredTags);

  @override
  List<Object?> get props => [allTags, filteredTags];
}
