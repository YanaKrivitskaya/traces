import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note_entity.dart';
import 'package:traces/screens/notes/tags/tag.dart';

//Models will contain plain dart classes which we will work with in our Flutter Application.
// Having the separation between models and entities allows us to switch our data provider at any time
// and only have to change the the toEntity and fromEntity conversion in our model layer.
@immutable
class Note{
  final String title;
  final String text;
  final String id;
  final DateTime dateCreated;
  final DateTime dateModified;
  final List<String> tagIds;

  Note(this.text, {String title, String id, DateTime dateCreated, DateTime dateModified, List<String> tagIds})
    : this.dateCreated = dateCreated ?? DateTime.now(),
      this.dateModified = dateModified ?? DateTime.now(),
      this.id = id,
      this.title = title ?? '',
      this.tagIds = tagIds ?? new List<String>();

  Note copyWith({String title, String text, DateTime dateCreated, DateTime dateModified, String id, List<String> tagIds}){
    return Note(
      text ?? this.text,
      title: title ?? this.title,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      id: id ?? this.id,
        tagIds: tagIds ?? this.tagIds
    );
  }

  @override
  int get hashCode =>
      title.hashCode ^ text.hashCode ^ dateCreated.hashCode ^ dateModified.hashCode ^ id.hashCode ^ tagIds.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
        other is Note &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          text == other.text &&
          dateCreated == other.dateCreated &&
          dateModified == other.dateModified &&
          id == other.id &&
          tagIds == other.tagIds;

  /*@override
  String toString(){
    return "Note {title: $title, text: $text, id: $id, dateCreated: $dateCreated, dateModified: $dateModified, tagIds: $tagIds}";
  }*/

  NoteEntity toEntity(){
    return NoteEntity(title, text, id, dateCreated, dateModified, tagIds);
  }

  static Note fromEntity(NoteEntity entity){
    return Note(
      entity.text,
      title: entity.title,
      id: entity.id,
      dateCreated: entity.dateCreated,
      dateModified: entity.dateModified,
      tagIds: entity.tagIds
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