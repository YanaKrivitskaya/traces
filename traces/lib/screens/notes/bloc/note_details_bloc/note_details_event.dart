import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../models/note.model.dart';


abstract class NoteDetailsEvent extends Equatable {
  const NoteDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetNoteDetails extends NoteDetailsEvent{
  final int? noteId;

  GetNoteDetails(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class NewNoteMode extends NoteDetailsEvent{
  final int? tripId;

  NewNoteMode(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class EditModeClicked extends NoteDetailsEvent{
  final Note? note;

  EditModeClicked(this.note);

  @override
  List<Object?> get props => [note];
}

class SaveNoteClicked extends NoteDetailsEvent{
  final Note note;
  final int? tripId;

  SaveNoteClicked(this.note, this.tripId);

  @override
  List<Object?> get props => [note, tripId];
}

class DeleteNote extends NoteDetailsEvent {
  final Note? note;

  const DeleteNote(this.note);

  @override
  List<Object?> get props => [note];
}

class GetImage extends NoteDetailsEvent{
  final File? image;

  const GetImage(this.image);

  @override
  List<Object?> get props => [image];
}
