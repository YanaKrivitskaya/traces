import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/tag.dart';

@immutable
abstract class TagEvent extends Equatable{

  const TagEvent();

  @override
  List<Object> get props => [];
}

class GetTags extends TagEvent{}

class AddTag extends TagEvent{
  final Tag tag;

  const AddTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class DeleteTag extends TagEvent{
  final Tag tag;

  const DeleteTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class UpdateTag extends TagEvent {
  final Tag tag;

  const UpdateTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class UpdateTagChecked extends TagEvent {
  final Tag tag;

  const UpdateTagChecked(this.tag);

  @override
  List<Object> get props => [tag];
}

class TagFilterChecked extends TagEvent {
  final Tag tag;

  const TagFilterChecked(this.tag);

  @override
  List<Object> get props => [tag];
}

class AllTagsChecked extends TagEvent {
  final bool checked;

  const AllTagsChecked(this.checked);

  @override
  List<Object> get props => [checked];
}

class NoTagsChecked extends TagEvent {
  final bool checked;

  const NoTagsChecked(this.checked);

  @override
  List<Object> get props => [checked];
}

class UpdateTagsList extends TagEvent {
  final List<Tag> tags;
  final List<Tag> filteredTags;
  final bool noTags;
  final List<Tag> selectedTags;

  const UpdateTagsList(this.tags, this.noTags, this.filteredTags, this.selectedTags);

  @override
  List<Object> get props => [tags, noTags, filteredTags, selectedTags];
}

class TagChanged extends TagEvent{
  final String tagName;

  const TagChanged({@required this.tagName});

  @override
  List<Object> get props => [tagName];
}

/*class GetTagsByQuery extends TagEvent {
  final String query;

  const GetTagsByQuery(this.query);

  @override
  List<Object> get props => [query];
}*/