import 'package:equatable/equatable.dart';

import '../../model/note.model.dart';

abstract class NoteDetailsEvent extends Equatable {
  const NoteDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetNoteDetails extends NoteDetailsEvent{
  final int noteId;

  GetNoteDetails(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class NewNoteMode extends NoteDetailsEvent{}

class EditModeClicked extends NoteDetailsEvent{
  final Note note;

  EditModeClicked(this.note);

  @override
  List<Object> get props => [note];
}

class SaveNoteClicked extends NoteDetailsEvent{
  final Note note;

  SaveNoteClicked(this.note);

  @override
  List<Object> get props => [note];
}
