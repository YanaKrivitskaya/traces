import 'package:intl/intl.dart';

class NoteModel{
  String _id;
  String _title;
  String _text;
  DateTime _dateCreated;
  DateTime _dateModified;
  String _tagId;

  NoteModel(this._id, this._title, this._text, this._dateCreated, this._dateModified);

  String get id => _id;
  String get title => _title;
  String get text => _text;
  DateTime get dateCreated => _dateCreated;
  DateTime get dateModified => _dateModified;
  String get tagId => _tagId;

  NoteModel.map(dynamic obj){
    this._id = obj['id'];
    this._title = obj['title'];
    this._text = obj['text'];
    this._dateCreated = obj['dateCreated'];
    this._dateModified = obj['dateModified'];
  }

  NoteModel.fromMap(Map<dynamic, dynamic> map){
    this._id = map["id"];
    this._title = map["title"];
    this._text = map["text"];
    this._dateCreated = map["dateCreated"].toDate();
    this._dateModified = map["dateModified"].toDate();
    this._tagId = map["tagId"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    (_title != '' && _title != null) ? map['title'] = _title : map['title'] = 'No title';
    map['text'] = text;
    map['dateModified'] = DateTime.now();
    map['dateCreated'] = _dateCreated;

    return map;
  }
}