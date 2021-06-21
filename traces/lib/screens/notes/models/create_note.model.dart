import 'dart:convert';

class CreateNoteModel {
  final String? title;
  final String? content;

  CreateNoteModel({
    this.title,
    this.content,
  }); 

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  factory CreateNoteModel.fromMap(Map<String, dynamic> map) {
    return CreateNoteModel(
      title: map['title'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateNoteModel.fromJson(String source) => CreateNoteModel.fromMap(json.decode(source));
}
