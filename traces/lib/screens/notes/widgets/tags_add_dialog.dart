
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/misc/state_types.dart';
import '../../../widgets/widgets.dart';
import '../bloc/note_details_bloc/bloc.dart';
import '../bloc/tag_add_bloc/bloc.dart';
import '../models/create_tag.model.dart';
import '../models/note.model.dart';
import '../models/tag.model.dart';

class TagsAddDialog extends StatefulWidget{
  final StringCallback callback;

  const TagsAddDialog({this.callback});

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
              if(_note.tags != null && _note.tags.isNotEmpty){
                _tags.forEach((t){
                  _note.tags.contains(t) ? t.isChecked = true : t.isChecked = false;
                });
              }else{
                _tags.forEach((t) => t.isChecked = false);
              }
            }
          }

          return new AlertDialog(
              title: Text('Select Tags'),
              actions: <Widget>[
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    widget.callback("Ok");
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.greenGrass)
                  ),
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
            CreateTagModel newTag = CreateTagModel(_tagController.text);
            context.read<TagAddBloc>().add(AddTag(newTag));
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
      )
    ],
  );

  void _onTagChanged() {
    context.read<TagAddBloc>().add(TagChanged(tagName: _tagController.text));
  }

  Widget _tagOptions() => new Column(
      children:
      _tags.map((Tag tag) => CheckboxListTile(
        title: Text(tag.name),
        value: tag.isChecked,
        onChanged: (checked) {

          Tag updatedTag = new Tag(name: tag.name, id: tag.id, isChecked: checked);

          checked ? _note.tags.add(tag) : _note.tags.remove(tag);

          context.read<TagAddBloc>().add(UpdateNoteTag(_note.id, updatedTag.id, checked));
        },
        activeColor: ColorsPalette.nycTaxi,
      )).toList()
  );
}