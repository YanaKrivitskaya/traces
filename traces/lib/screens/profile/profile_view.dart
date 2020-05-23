import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traces/auth/bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/screens/profile/bloc/bloc.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/name_edit_button.dart';

class ProfileView extends StatefulWidget{

  ProfileView();
  State<ProfileView> createState() => _ProfileViewState();

}

class _ProfileViewState extends State<ProfileView>{

  Profile _profile;
  List<Family> _familyMembers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        if(state.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        if(state.isSuccess){
          _profile = state.profile;
          _familyMembers = state.familyMembers;

          return Container(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: ColorsPalette.lynxWhite,
                          child: Text(_getAvatarName(), style: TextStyle(color: ColorsPalette.meditSea, fontSize: 40.0, fontWeight: FontWeight.w300),),
                          radius: 50.0
                      ),
                      Expanded(child: Align(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_profile.displayName, style: TextStyle(fontSize: 20.0)),
                          NameEditButton()
                          //IconButton(icon: Icon(Icons.edit, size: 20.0, color: ColorsPalette.meditSea,), onPressed: (){})
                        ],
                      ), alignment: Alignment.center,))
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Row(children: <Widget>[
                      Text("Email: " + _profile.email, style: TextStyle(fontSize: 15.0)),
                      _profile.isEmailVerified
                          ? IconButton(icon: Icon(Icons.check, color: ColorsPalette.meditSea), tooltip: 'Verified')
                          : IconButton(icon: Icon(Icons.error_outline, color: ColorsPalette.fusionRed), tooltip: 'Not verified'),
                    ],),
                  ),
                  /*Align(
           alignment: Alignment.centerLeft,
           child: FlatButton(
             color: ColorsPalette.fusionRed,
             child: Text("Verify email", style: TextStyle(color: ColorsPalette.lynxWhite),),
             onPressed: (){},
           ),
         ),*/
                  Divider(color: ColorsPalette.meditSea,),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,child: Text("Family", style: TextStyle(fontSize: 20.0, color: ColorsPalette.meditSea)),
                        ),
                        _familyMembers.length > 0
                            ? Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _familyMembers.length,
                              itemBuilder: (context, position){
                                final member = _familyMembers[position];
                                return ListTile(
                                  title: Text(member.name),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 15.0),
                                );
                              }),
                        )
                            : Container(child: Align(child: Text("No one added yet"), alignment: Alignment.centerLeft,),),
                        /*ListTile(
                        title: Text("SP"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15.0),
                      ),*/
                        Align(
                            alignment: Alignment.centerLeft,child: OutlineButton(child: Text("Add...", style: TextStyle(color: ColorsPalette.fusionRed),))
                        ),
                      ],
                    ),
                  ),

                  _footer()
                ],
              ),
            )
          );
        }else return Container();
      },
    );
  }

  String _getAvatarName(){
    if(_profile.displayName.length <= 3) return _profile.displayName.toUpperCase();
    if(_profile.displayName.contains(' ')){
      List<String> nameParts = _profile.displayName.split(' ');
      String avatarName = '';
      nameParts.forEach((n) {
        avatarName += n.substring(0, 1);
      });
      if(avatarName.length > 3) return avatarName.substring(0, 3);
      return avatarName;
    }else{
      return _profile.displayName.substring(0, 1);
    }
  }

  Widget _footer(){
    return Expanded(
      child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Divider(color: ColorsPalette.meditSea),
                OutlineButton(
                  child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: ColorsPalette.fusionRed),
                      title: Text('Sign out')),
                  onPressed: (){
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(Navigator.defaultRouteName, (Route<dynamic> route) => false);
                  },),],
            ))
      ));
  }

}