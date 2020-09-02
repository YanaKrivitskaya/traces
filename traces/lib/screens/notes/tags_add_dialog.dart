
import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/notes/bloc/note_details_bloc/bloc.dart';
import 'package:traces/screens/notes/bloc/tag_add_bloc/bloc.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:traces/shared/state_types.dart';

class TagsAddDialog extends StatefulWidget{

  const TagsAddDialog();

  @override
  _TagsAddDialogState createState() => new _TagsAddDialogState();
}

class _TagsAddDialogState extends State<TagsAddDialog>{
  List<Tag> _tags;

  Note _note;

  TextEditingController _tagController;

  @override
  void initState() {
    super.initState();

    _tagController = new TextEditingController(text: '');
    _tagController.addListener(_onTagChanged);

    _note = BlocProvider.of<NoteDetailsBloc>(context).state.note;
  }

  @override
  void dispose(){
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TagAddBloc, TagAddState>(
        builder: (context, state) {

          if(state.status == StateStatus.Success){
            _tags = state.filteredTags;
            if(_tags != null){
              if(_note.tagIds != null && _note.tagIds.isNotEmpty){
                _tags.forEach((t){
                  _note.tagIds.contains(t.id) ? t.isChecked = true : t.isChecked = false;
                });
              }else{
                _tags.forEach((t) => t.isChecked = false);
              }
            }
          }

          return new AlertDialog(
              title: Text('Select Tags'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: ColorsPalette.greenGrass,
                ),
              ],
              content: Container(
                child: Column(
                  children: <Widget>[
                    _addSearchTagField(),
                    Divider(color: ColorsPalette.nycTaxi),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          state.status == StateStatus.Success && _tags.length > 0
                              ? _tagOptions()
                              : state.status == StateStatus.Loading
                                ? Center(child: CircularProgressIndicator(),)
                                : Text("No tags found")
                        ],),),
                    )],),)
          );
        });
  }
  
  Widget _addSearchTagField() => new Row(
    children: <Widget>[
      Expanded(
        child: TextFormField(
          decoration: const InputDecoration(
              hintText: 'Search/Add',
              border: InputBorder.none
            ),
          controller: _tagController,
          keyboardType: TextInputType.text,
        ),
      ),
      IconButton(
        icon: Icon(Icons.add, color: ColorsPalette.greenGrass),
        onPressed: (){
          if(_tagController.text != ''){
            Tag newTag = Tag(_tagController.text);
            context.bloc<TagAddBloc>().add(AddTag(newTag));
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
      )
    ],
  );

  void _onTagChanged() {
    context.bloc<TagAddBloc>().add(TagChanged(tagName: _tagController.text));
  }

  Widget _tagOptions() => new Column(
      children:
      _tags.map((Tag tag) => CheckboxListTile(
        title: Text(tag.name + " (" + tag.usage.toString() + ")"),
        value: tag.isChecked,
        onChanged: (checked) {

          Tag updatedTag = new Tag(tag.name, id: tag.id, usage: checked ? tag.usage +1 : tag.usage -1, isChecked: checked);

          checked ? _note.tagIds.add(tag.id) : _note.tagIds.remove(tag.id);

          context.bloc<NoteDetailsBloc>().add(SaveNoteClicked(_note));
          context.bloc<TagAddBloc>().add(UpdateTag(updatedTag));
        },
        activeColor: ColorsPalette.nycTaxi,
      )).toList()
  );
}