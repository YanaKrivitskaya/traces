import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class DetailsState extends Equatable{
  const DetailsState();

  @override
  List<Object> get props => [];
}

class InitialDetailsState extends DetailsState {}

class ViewDetailsState extends DetailsState {
  final Note note;

  const ViewDetailsState(this.note);

  @override
  List<Object> get props => [note];
}

class EditDetailsState extends DetailsState {
  final Note note;
  const EditDetailsState(this.note);

  @override
  List<Object> get props => [note];
}

class AddNoteState extends DetailsState {
  final Note note;
  const AddNoteState(this.note);

  @override
  List<Object> get props => [note];
}

class LoadingDetailsState extends DetailsState {}
