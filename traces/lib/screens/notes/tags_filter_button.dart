import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/notes/bloc/tag_filter_bloc/bloc.dart';
import 'package:traces/screens/notes/model/tag.dart';

import 'bloc/note_bloc/bloc.dart';

class TagsFilterButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.turned_in_not, color: Colors.white),
        onPressed: () {
          showDialog(
              barrierDismissible: false, context: context, builder: (_) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                      value: context.bloc<TagFilterBloc>()..add(GetTags())
                  ),
                  BlocProvider.value(
                    value: context.bloc<NoteBloc>(),
                  ),
                ],
                child:  TagsDialog(),
              )
          );
        }
    );
  }
}

class TagsDialog extends StatefulWidget{

  const TagsDialog();

  @override
  _TagsDialogState createState() => new _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog>{

  List<Tag> _tags;
  List<Tag> _selectedTags;
  Tag _selectAll = Tag("All", isChecked: true);
  Tag _noTags = Tag("No tags", isChecked: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return BlocBuilder<TagFilterBloc, TagFilterState>(
        builder: (context, state) {
          if(state.isSuccess){

            _tags = state.allTags;
            _selectedTags = state.selectedTags ?? state.allTags;
            _noTags.isChecked = state.noTagsChecked;
            _selectAll.isChecked = state.allTagsChecked;

            // uncheck all
            if(state.allUnChecked){
              _tags.forEach((t) => t.isChecked = false);
              _noTags.isChecked = false;
            }

            //check all
            else if(_selectAll.isChecked){
              _tags.forEach((t) => t.isChecked = true);
              _noTags.isChecked = true;
            }

            //check selected
            else if (_tags != null && !_selectAll.isChecked) {
              if (_selectedTags != null) {
                for(var i=0; i< _tags.length; i++){
                  if(_selectedTags.where((tag) => tag.id == _tags[i].id).toList().length > 0){
                    _tags[i].isChecked = true;
                  }else _tags[i].isChecked = false;
                }
              } else {
                _tags.forEach((t) => t.isChecked = true);
              }
            }

          }
          return new AlertDialog(
            title: Text('Tags'),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  context.bloc<NoteBloc>().add(SelectedTagsUpdated());
                  Navigator.pop(context);
                },
                textColor: ColorsPalette.greenGrass,
              ),
            ],
            content: Container(
              child: Column(
                children: <Widget>[
                  _selectAllOptions(),
                  _selectNoTags(),
                  Divider(color: ColorsPalette.blueHorizon),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[_tagOptions()],),),
                  )],),)
          );
        });
  }

  Widget _tagOptions() => new Column(
    children:
    _tags.map((Tag tag) => CheckboxListTile(
      title: Text(tag.name + " (" + tag.usage.toString() + ")"),
      value: tag.isChecked,
      onChanged: (val) {
        context.bloc<TagFilterBloc>().add(TagChecked(tag, val));
      },
    )).toList()
  );

  Widget _selectAllOptions() => new Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text(_selectAll.name),
          value: _selectAll.isChecked,
          onChanged: (val) {
            _selectAll.isChecked = val;
            context.bloc<TagFilterBloc>().add(AllTagsChecked(val));
          },
        )
      ],
  );

  Widget _selectNoTags() => new Column(
    children: <Widget>[
      CheckboxListTile(
        title: Text(_noTags.name),
        value: _noTags.isChecked,
        onChanged: (val) {
          _noTags.isChecked = val;
          context.bloc<TagFilterBloc>().add(NoTagsChecked(val));
        },
      )
    ],
  );
}
