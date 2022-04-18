import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/notes/models/note.model.dart';
import 'package:traces/screens/notes/models/tag.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:intl/intl.dart';

class NoteTileView extends StatelessWidget{
  final Note note; 
  final bool allTagsSelected; 
  final List<Tag>? selectedTags;
 
  NoteTileView(this.note, this.allTagsSelected, this.selectedTags);

  @override
  Widget build(BuildContext context) {
    return Container(      
      child: Column(children: [
        ListTile(              
          leading: note.image != null ? Icon(Icons.image, size: 30.0, color: ColorsPalette.juicyOrangeLight,) : Icon(Icons.notes_outlined, size: 30.0, color: ColorsPalette.frLightBlue,),
          title: Text('${note.title}', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)),
          subtitle: (note.createdDate!.day.compareTo(note.updatedDate!.day) == 0) ?
          Text('${DateFormat.yMMMd().format(note.updatedDate!)}',
              style: quicksandStyle(color: ColorsPalette.black, fontSize: 15.0)) :
          Text('${DateFormat.yMMMd().format(note.updatedDate!)} / ${DateFormat.yMMMd().format(note.createdDate!)}',
              style: quicksandStyle(color: ColorsPalette.black, fontSize: 15.0))                                          
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          alignment: Alignment.centerLeft,
          child: note.tags!.isNotEmpty ? getChips(note, allTagsSelected, selectedTags): Container(),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(color: ColorsPalette.juicyBlue),
        ),                                        
        note.content != null ? InkWell(child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10.0),
          child: Text(note.content!.substring(0, note.content!.length > 100 ? 100 : note.content!.length), style: quicksandStyle(fontSize: 15.0)),
        )
        ) : Container()
      ])
    );
}

   Widget getChips(Note note, bool? allTagsSelected, List<Tag>? selectedTags) {    
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: note.tags!
              .map((tag) => Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("#"+tag.name!, style: quicksandStyle(
                  color: ColorsPalette.juicyBlue,
                  fontSize: 13.0,
                  weight: _isTagSelected(tag, allTagsSelected, selectedTags) ? FontWeight.bold : FontWeight.normal))
          ))
              .toList(),
        ));
  }

  bool _isTagSelected(Tag tag, bool? allTagsSelected, List<Tag>? selectedTags){
    if(selectedTags != null && selectedTags.any((t) => t.id == tag.id) && !allTagsSelected!) return true;
    return false;
  }

}