import 'package:intl/intl.dart';

class NoteModel{
  String _id;
  String _title;
  String _text;
  DateTime _dateCreated;
  DateTime _dateModified;
  String _categoryId;

  NoteModel(this._id, this._title, this._text, this._dateCreated, this._dateModified);

  String get id => _id;
  String get title => _title;
  String get text => _text;
  DateTime get dateCreated => _dateCreated;
  DateTime get dateModified => _dateModified;
  String get categoryId => _categoryId;

  NoteModel.map(dynamic obj){
    this._id = obj['id'];
    this._title = obj['title'];
    this._text = obj['text'];
    this._dateCreated = obj['dateCreated'];
    this._dateModified = obj['dateModified'];
    this._categoryId = obj['categoryId'];
  }

  NoteModel.fromMap(Map<dynamic, dynamic> map){
    this._id = map["id"];
    this._title = map["title"];
    this._text = map["text"];
    this._dateCreated = map["dateCreated"].toDate();
    this._dateModified = map["dateModified"].toDate();
    this._categoryId = map["categoryId"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    (_title != '' && _title != null) ? map['title'] = _title : map['title'] = 'No title';
    map['text'] = text;
    map['dateModified'] = DateTime.now();
    map['dateCreated'] = _dateCreated;
    map['categoryId'] = _categoryId;

    return map;
  }
}

class CategoryModel{
  String _id;
  String _name;
  int _usage;

  CategoryModel(this._id, this._name);

  String get id => _id;
  String get name => _name;
  int get usage => _usage;

  CategoryModel.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
    this._usage = obj['usage'];
  }

  CategoryModel.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._usage = map["usage"];
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    map['name'] = name;
    map['usage'] = usage;

    return map;
  }
}