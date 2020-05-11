import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/tags/bloc/bloc.dart';
import 'package:traces/screens/notes/tags/tag.dart';

class TagsManagementButton extends StatelessWidget{
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
                      value: context.bloc<TagBloc>()
                  ),
                  BlocProvider.value(
                    value: context.bloc<NotesBloc>(),
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
  Tag _selectAll = Tag("All", isChecked: true);
  Tag _noTags = Tag("No tags", isChecked: true);

  @override
  void initState() {
    super.initState();
    _tags = BlocProvider.of<TagBloc>(context).state.tags;
  }

  @override
  Widget build(BuildContext context){

    return BlocBuilder<TagBloc, TagState>(
        builder: (context, state) {
          if(state is TagsLoadSuccess){
            _tags = state.tags;
            _tags.any((t) => t.isChecked == false) || !state.noTags ? _selectAll.isChecked = false : _selectAll.isChecked=true;
            _noTags.isChecked = state.noTags;
          }
          return new AlertDialog(
            title: Text('Tags'),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  context.bloc<TagBloc>().add(UpdateTagsList(_tags, _noTags.isChecked));
                  context.bloc<NotesBloc>().add(UpdateTagsFilter(_tags.where((t) => t.isChecked).toList(), _selectAll.isChecked, _noTags.isChecked));
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);},
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
        tag.isChecked = val;
        context.bloc<TagBloc>().add(UpdateTagChecked(tag));
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
            context.bloc<TagBloc>().add(AllTagsChecked(val));
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
          context.bloc<TagBloc>().add(NoTagsChecked(val));
        },
      )
    ],
  );
}
