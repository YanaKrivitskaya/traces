import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:meta/meta.dart';

abstract class TagAddEvent extends Equatable {
  const TagAddEvent();

  @override
  List<Object> get props => [];
}

class GetTags extends TagAddEvent{}

class AddTag extends TagAddEvent{
  final Tag tag;

  const AddTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class UpdateTag extends TagAddEvent {
  final Tag tag;

  const UpdateTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class TagChanged extends TagAddEvent{
  final String tagName;

  const TagChanged({@required this.tagName});

  @override
  List<Object> get props => [tagName];
}

class UpdateTagsList extends TagAddEvent {
  final List<Tag> allTags;
  final List<Tag> filteredTags;

  const UpdateTagsList(this.allTags, this.filteredTags);

  @override
  List<Object> get props => [allTags, filteredTags];
}
