import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/tags/tag.dart';

@immutable
abstract class NotesEvent extends Equatable{
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class GetNotes extends NotesEvent {}

class AddNote extends NotesEvent{
  final Note note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNotesList extends NotesEvent {
  final List<Note> notes;
  final SortFields sortField;
  final SortDirections sortDirection;
  final bool allTagsSelected;

  const UpdateNotesList(this.notes, this.sortField, this.sortDirection, this.allTagsSelected);

  @override
  List<Object> get props => [notes, sortField, sortDirection, allTagsSelected];

  @override
  String toString(){
    return '''NotesEvent{      
      notes: $notes,
      sortField: $sortField,
      sortDirection: $sortDirection,
      allTagsSelected: $allTagsSelected
    }''';
  }
}

class UpdateSortOrder extends NotesEvent {
  final SortFields sortField;
  final SortDirections sortDirection;

  const UpdateSortOrder(this.sortField, this.sortDirection);

  @override
  List<Object> get props => [sortField, sortDirection];
}

class UpdateTagsFilter extends NotesEvent {
  final bool allTagsSelected;
  final bool noTags;
  final List<Tag> tags;

  const UpdateTagsFilter(this.tags, this.allTagsSelected, this.noTags);

  @override
  List<Object> get props => [tags, allTagsSelected, noTags];
}
