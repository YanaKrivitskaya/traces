import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note-entity.dart';

@immutable
class Note{
  final String title;
  final String text;
  final String id;
  final DateTime dateCreated;
  final DateTime dateModified;

  Note(this.text, {String title, String id, DateTime dateCreated, DateTime dateModified})
    : this.dateCreated = dateCreated ?? DateTime.now(),
      this.dateModified = dateModified ?? DateTime.now(),
      this.id = id,
      this.title = title ?? '';

  Note copyWith({String title, String text, DateTime dateCreated, DateTime dateModified, String id}){
    return Note(
      text ?? this.text,
      title: title ?? this.title,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      id: id ?? this.id
    );
  }

  @override
  int get hashCode =>
      title.hashCode ^ text.hashCode ^ dateCreated.hashCode ^ dateModified.hashCode ^ id.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
        other is Note &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          text == other.text &&
          dateCreated == other.dateCreated &&
          dateModified == other.dateModified &&
          id == other.id;

  @override
  String toString(){
    return "Note {title: $title, text: $text, id: $id, dateCreated: $dateCreated, dateModified: $dateModified}";
  }

  NoteEntity toEntity(){
    return NoteEntity(title, text, id, dateCreated, dateModified);
  }

  static Note fromEntity(NoteEntity entity){
    return Note(
      entity.text,
      title: entity.title,
      id: entity.id,
      dateCreated: entity.dateCreated,
      dateModified: entity.dateModified
    );
  }
}

enum SortFields{
  TITLE,
  DATECREATED,
  DATEMODIFIED
}
enum SortDirections{
  ASC,
  DESC
}