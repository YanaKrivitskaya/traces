import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/color_constants.dart';
import '../../utils/misc/state_types.dart';
import 'bloc/profile/bloc.dart';
import 'model/group_user_model.dart';

class FamilyDialog extends StatefulWidget{
  final GroupUser? groupUser;
  final int groupId;

  FamilyDialog(this.groupUser, this.groupId);

  @override
  _FamilyDialogState createState() => new _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog>{
  TextEditingController? _usernameController;

  @override
  void initState() {
    super.initState();

    _usernameController = new TextEditingController(text: '');
    _usernameController!.addListener(_onUsernameChanged);
  }

  @override
  void dispose(){
    _usernameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {

          if(state.status == StateStatus.Loading){
            return new Center(child: CircularProgressIndicator());
          }else{

            if(widget.groupUser != null && state.mode == StateMode.View){
              _usernameController!.text = widget.groupUser!.name;
            }

            return new AlertDialog(
              title: Text('Family member'),
              actions: <Widget>[
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    if(state.isUsernameValid){
                      context.read<ProfileBloc>().add(FamilyUpdated(name: _usernameController!.text.trim(), 
                        userId: widget.groupUser?.userId ?? null, groupId: widget.groupId));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.meditSea)
                  ),  
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                    foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.meditSea)
                  ),                  
                ),
              ],
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _usernameTextField(_usernameController, state),
                    ],
                ),
              ),
            );
          }
        }
    );
  }

  Widget _usernameTextField(TextEditingController? usernameController, ProfileState state) => new TextFormField(
    decoration: InputDecoration(
        labelText: 'Name',
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
            color: ColorsPalette.meditSea, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
            color: ColorsPalette.meditSea, width: 1),
        )
    ),
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (_) {
      return !state.isUsernameValid ? 'Invalid Name' : null;
    },
    autofocus: false,
    controller: usernameController,
  );

  void _onUsernameChanged() {
    context.read<ProfileBloc>().add(UsernameChanged(username: _usernameController!.text.trim()));
  }

}
