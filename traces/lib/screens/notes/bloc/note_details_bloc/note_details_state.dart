import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:traces/screens/notes/model/tag.dart';

abstract class NoteDetailsState extends Equatable {
  final Note note;

  const NoteDetailsState(this.note);

  @override
  List<Object> get props => [];
}

class LoadingDetailsState extends NoteDetailsState {
  LoadingDetailsState(Note note) : super(note);
}

class ViewDetailsState extends NoteDetailsState {
  final Note note;
  final List<Tag> noteTags;

  const ViewDetailsState(this.note, this.noteTags) : super(note);

  @override
  List<Object> get props => [note, noteTags];
}

class EditDetailsState extends NoteDetailsState {
  final Note note;

  const EditDetailsState(this.note) : super(note);

  @override
  List<Object> get props => [note];
}

class InitialNoteDetailsState extends NoteDetailsState {
  InitialNoteDetailsState(Note note) : super(note);
}
