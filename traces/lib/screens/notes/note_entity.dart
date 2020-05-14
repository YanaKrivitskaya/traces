import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

//represent the data provided by our data provider.
class NoteEntity extends Equatable{
  final String title;
  final String text;
  final String id;
  final DateTime dateCreated;
  final DateTime dateModified;
  final List<String> tagIds;

  const NoteEntity(this.title, this.text, this.id, this.dateCreated, this.dateModified, this.tagIds);

  Map<String, Object> toJson(){
    return{
      "title": title,
      "text": text,
      "id": id,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
      "tagIds": tagIds
    };
  }

  @override
  List<Object> get props => [title, text, id, dateCreated, dateModified, tagIds];

  @override
  String toString(){
    return "NoteEntity: {title: $title, text: $text, id: $id, dateCreated: $dateCreated, dateModified: $dateModified, tagIds: $tagIds}";
  }

  static NoteEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return NoteEntity(
      map["title"] as String,
      map["text"] as String,
      documentId,
      map["dateCreated"].toDate(),
      map["dateModified"].toDate(),
      map["tagIds"] != null ? map["tagIds"].cast<String>() as List<String> : null
    );
  }

  static NoteEntity fromSnapshot(DocumentSnapshot snap){
    return NoteEntity(
        snap.data['title'],
        snap.data['text'],
        snap.documentID,
        snap.data['dateCreated'].toDate(),
        snap.data['dateModified'].toDate(),
        snap.data['tagIds']!= null ? snap.data['tagIds'].cast<String>() : null
    );
  }

  Map<String, Object> toDocument(){
    return{
      "title": title!= '' ? title : 'No Title',
      "text": text,
      "dateCreated": dateCreated,
      "dateModified": DateTime.now(),
      "tagIds": tagIds
    };
  }
}