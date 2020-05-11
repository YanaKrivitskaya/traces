import 'package:meta/meta.dart';
import 'package:traces/screens/notes/tags/tag_entity.dart';


@immutable
class Tag{
  final String id;
  final String name;
  final int usage;
  bool isChecked;

  Tag(this.name, {String id,int usage, bool isChecked})
      :this.id = id,
       this.usage = usage ?? 0,
       this.isChecked = isChecked ?? true;

  Tag copyWith({String id, String name, int usage, bool isChecked}){
    return Tag(
        name ?? this.name,
        id: id ?? this.id,
        usage: usage ?? this.usage,
        isChecked: isChecked ?? this.isChecked
    );
  }

  TagEntity toEntity(){
    return TagEntity(id, name, usage);
  }

  static Tag fromEntity(TagEntity entity){
    return Tag(
        entity.name,
        id: entity.id,
        usage: entity.usage,
        isChecked: true
    );
  }


}