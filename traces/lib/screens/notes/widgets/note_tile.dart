import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/style/styles.dart';
import '../models/note.model.dart';
import '../models/tag.model.dart';

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
          leading: note.image != null ? Icon(Icons.image, size: iconSize, color: ColorsPalette.juicyOrangeLight,) : Icon(Icons.notes_outlined, size: 30.0, color: ColorsPalette.frLightBlue,),
          title: Text('${note.title}', style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
          subtitle: (note.createdDate!.day.compareTo(note.updatedDate!.day) == 0) ?
          Text('${DateFormat.yMMMd().format(note.updatedDate!)}',
              style: quicksandStyle(color: ColorsPalette.black, fontSize: fontSizesm)) :
          Text('${DateFormat.yMMMd().format(note.updatedDate!)} / ${DateFormat.yMMMd().format(note.createdDate!)}',
              style: quicksandStyle(color: ColorsPalette.black, fontSize: fontSizesm))                                          
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: borderPadding),
          alignment: Alignment.centerLeft,
          child: note.tags!.isNotEmpty ? getChips(note, allTagsSelected, selectedTags): SizedBox(height:0),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: borderPadding),
          child: Divider(color: ColorsPalette.juicyBlue),
        ),                                        
        note.content != null ? InkWell(child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(borderPadding),
          child: Text(note.content!.substring(0, note.content!.length > 100 ? 100 : note.content!.length), style: quicksandStyle(fontSize: fontSizesm)),
        )
        ) : SizedBox(height:0)
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