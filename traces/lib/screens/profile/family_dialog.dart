import 'package:flutter/material.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/profile/bloc/family/family_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/model/family.dart';

class FamilyDialog extends StatefulWidget{

  @override
  _FamilyDialogState createState() => new _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog>{
  TextEditingController _usernameController;
  List<String> _genders = ['Male', 'Female'];
  String _selectedGender = 'Male';
  Color formColor;

  @override
  void initState() {
    super.initState();

    _usernameController = new TextEditingController(text: '');
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose(){
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {

          if(state.isLoading){
            return new Center(child: CircularProgressIndicator());
          }else{
            _selectedGender = state.selectedGender;
            _selectedGender == 'Male' ? formColor = ColorsPalette.meditSea : formColor = ColorsPalette.fusionRed;

            if(!state.isNewMode && !state.isEditing){
              _usernameController.text = context.bloc<FamilyBloc>().state.familyMember.name;
            }

            return new AlertDialog(
              title: Text('Add member'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    if(state.isUsernameValid){
                      if(state.isNewMode){
                        Family newMember = Family(_usernameController.text, gender: state.selectedGender);
                        context.bloc<FamilyBloc>().add(FamilyAdded(newMember: newMember));
                      }else{
                        Family updMember = Family(_usernameController.text, gender: state.selectedGender, id: state.familyMember.id);
                        context.bloc<FamilyBloc>().add(FamilyUpdated(updMember: updMember));
                      }
                    }
                    Navigator.pop(context);
                  },
                  textColor: ColorsPalette.meditSea,
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: ColorsPalette.meditSea,
                ),
              ],
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _usernameTextField(_usernameController, state),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: _genderSelector(state),
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );
  }

  Widget _usernameTextField(TextEditingController usernameController, FamilyState state) => new TextFormField(
    decoration: InputDecoration(
        labelText: 'Name',
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
            color: formColor, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
            color: formColor, width: 1),
        )
    ),
    keyboardType: TextInputType.text,
    autovalidate: true,
    validator: (_) {
      return !state.isUsernameValid ? 'Invalid Name' : null;
    },
    autofocus: false,
    controller: usernameController,
  );

  Widget _genderSelector(FamilyState state) => new DropdownButton<String>(
    value: _selectedGender,
    isExpanded: true,
    hint: new Text("Select Gender"),
    underline: Container(
      height: 1,
      color: formColor,
    ),
    items: _genders.map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList(),
    onChanged: (String value) {
      context.bloc<FamilyBloc>().add(GenderUpdated(gender: value));
    },
  );

  void _onUsernameChanged() {
    context.bloc<FamilyBloc>().add(UsernameFamilyChanged(username: _usernameController.text));
  }

}
