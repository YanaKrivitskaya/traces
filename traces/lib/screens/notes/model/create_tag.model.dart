import 'dart:convert';

class CreateTagModel {
  final String name;

  CreateTagModel(this.name);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory CreateTagModel.fromMap(Map<String, dynamic> map) {
    return CreateTagModel(
      map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateTagModel.fromJson(String source) => CreateTagModel.fromMap(json.decode(source));
}
