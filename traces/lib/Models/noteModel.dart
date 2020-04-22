import 'package:intl/intl.dart';

class NoteModel{
  String _id;
  String _title;
  String _text;
  DateTime _dateCreated;
  DateTime _dateModified;
  List<String> _tagIds;

  NoteModel(this._id, this._title, this._text, this._dateCreated, this._dateModified);

  String get id => _id;
  String get title => _title;
  String get text => _text;
  DateTime get dateCreated => _dateCreated;
  DateTime get dateModified => _dateModified;
  List<String> get tagIds => _tagIds;

  NoteModel.map(dynamic obj){
    this._id = obj['id'];
    this._title = obj['title'];
    this._text = obj['text'];
    this._dateCreated = obj['dateCreated'];
    this._dateModified = obj['dateModified'];
    this._tagIds = obj['tagIds'];
  }

  NoteModel.fromMap(Map<dynamic, dynamic> map){
    this._id = map["id"];
    this._title = map["title"];
    this._text = map["text"];
    this._dateCreated = map["dateCreated"].toDate();
    this._dateModified = map["dateModified"].toDate();
    this._tagIds = new List<String>.from(map["tagIds"]);
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    (_title != '' && _title != null) ? map['title'] = _title : map['title'] = 'No title';
    map['text'] = text;
    map['dateModified'] = DateTime.now();
    map['dateCreated'] = _dateCreated;
    map['tagIds'] = tagIds;

    return map;
  }
}

class TagModel{
  String _id;
  String _name;

  TagModel(this._id, this._name);

  String get id => _id;
  String get name => _name;

  TagModel.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
  }

  TagModel.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    map['name'] = name;

    return map;
  }
}