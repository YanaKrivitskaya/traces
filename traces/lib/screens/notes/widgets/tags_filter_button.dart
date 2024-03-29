import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traces/widgets/error_widgets.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/misc/state_types.dart';
import '../../../widgets/widgets.dart';
import '../bloc/note_bloc/bloc.dart';
import '../bloc/tag_filter_bloc/bloc.dart';
import '../models/tag.model.dart';

class TagsFilterButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(right: 10.0),
      constraints: BoxConstraints(),      
        icon: Icon(Icons.tag, color: ColorsPalette.black),
        onPressed: () {
          showDialog(
              barrierDismissible: false, context: context, builder: (_) =>
              MultiBlocProvider(
                providers: [                  
                  BlocProvider.value(
                    value: context.read<TagFilterBloc>()..add(GetTags()),
                  ),
                  BlocProvider.value(
                    value: context.read<NoteBloc>(),
                  ),
                ],
                child: TagsDialog(),
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

  List<Tag>? _tags;
  List<Tag>? _selectedTags;
  Tag _selectAll = Tag(name: "All", isChecked: true);
  Tag _noTags = Tag(name: "No tags", isChecked: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){    
    return BlocBuilder<TagFilterBloc, TagFilterState>(
        builder: (context, state) {
          if(state.status == StateStatus.Success || state.status == StateStatus.Error){
            if(state.status == StateStatus.Success){
              _tags = state.allTags;
              _selectedTags = state.selectedTags ?? state.allTags;
              _noTags.isChecked = state.noTagsChecked;
              _selectAll.isChecked = state.allTagsChecked;

              // uncheck all
              if(state.allUnChecked!){
                _tags!.forEach((t) => t.isChecked = false);
                _noTags.isChecked = false;
              }

              //check all
              else if(_selectAll.isChecked!){
                _tags!.forEach((t) => t.isChecked = true);
                _noTags.isChecked = true;
              }

              //check selected
              else if (_tags != null && !_selectAll.isChecked!) {
                if (_selectedTags != null) {
                  for(var i=0; i< _tags!.length; i++){
                    if(_selectedTags!.where((tag) => tag.id == _tags![i].id).toList().length > 0){
                      _tags![i].isChecked = true;
                    }else _tags![i].isChecked = false;
                  }
                } else {
                  _tags!.forEach((t) => t.isChecked = true);
                }
              }
            }            
            return new AlertDialog(
            title: Text('Tags'),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {                  
                  context.read<NoteBloc>().add(SelectedTagsUpdated(state.selectedTags, state.allTagsChecked, state.noTagsChecked));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.greenGrass)
                ),                
              ),
            ],
            content: state.status == StateStatus.Success ? Container(
              child: Column(
                children: <Widget>[
                  _selectAllOptions(),
                  _selectNoTags(),
                  Divider(color: ColorsPalette.blueHorizon),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[_tagOptions()],),),
                  )],),) : state.status == StateStatus.Error && state.errorMessage != null 
                  ? errorWidget(context, error: state.errorMessage!)
                  : loadingWidget(ColorsPalette.nycTaxi)
          );
          }
          return loadingWidget(ColorsPalette.greenGrass);
        });
  }

  Widget _tagOptions() => new Column(
    children:
    _tags!.map((Tag tag) => CheckboxListTile(
      title: Text(tag.name!),
      value: tag.isChecked,
      onChanged: (val) {
        context.read<TagFilterBloc>().add(TagChecked(tag, val));
      },
      activeColor: ColorsPalette.nycTaxi,
    )).toList()
  );

  Widget _selectAllOptions() => new Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text(_selectAll.name!),
          value: _selectAll.isChecked,
          onChanged: (val) {
            _selectAll.isChecked = val;
            context.read<TagFilterBloc>().add(AllTagsChecked(val));
          },
          activeColor: ColorsPalette.nycTaxi,
        )
      ],
  );

  Widget _selectNoTags() => new Column(
    children: <Widget>[
      CheckboxListTile(
        title: Text(_noTags.name!),
        value: _noTags.isChecked,
        onChanged: (val) {
          _noTags.isChecked = val;
          context.read<TagFilterBloc>().add(NoTagsChecked(val));
        },
        activeColor: ColorsPalette.nycTaxi,
      )
    ],
  );
}
