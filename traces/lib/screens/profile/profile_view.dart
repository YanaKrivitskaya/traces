import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/auth_bloc/bloc.dart';
import '../../constants/color_constants.dart';
import '../../utils/misc/state_types.dart';
import '../../utils/style/styles.dart';
import '../../widgets/widgets.dart';
import 'add_family_button.dart';
import 'bloc/profile/bloc.dart';
import 'family_dialog.dart';
import 'model/group_model.dart';
import 'model/profile_model.dart';
import 'name_edit_button.dart';
import 'user_delete_alert.dart';
import 'vertical_user_list_item.dart';


class ProfileView extends StatefulWidget{

  ProfileView();
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>{
  SlidableController? slidableController; 
  Profile? _profile;
  Group? _familyGroup;

  void initState() { 
    slidableController = SlidableController();
    super.initState(); 
  }

  // for Slidable animation
  void handleSlideIsOpenChanged(bool isOpen) { }
  void handleSlideAnimationChanged(Animation<double> slideAnimation) { }  
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state){
        if(state.status == StateStatus.Error){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        state.errorMessage!, style: quicksandStyle(color: ColorsPalette.lynxWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Icon(Icons.error, color: ColorsPalette.lynxWhite,)],
                ),
               // duration: const Duration(seconds: 5),
                backgroundColor: ColorsPalette.redPigment,
              ),
            );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        if(state.status == StateStatus.Loading){
          return Center(child: CircularProgressIndicator());
        }
        if(state.status == StateStatus.Success || state.status == StateStatus.Error){
          _profile = state.profile;
          _familyGroup = _profile!.groups?.firstWhere((g) => g.name == "Family" && g.ownerAccountId == _profile!.accountId, orElse: null);

          return Container(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: ColorsPalette.lynxWhite,
                          child: Text(getAvatarName(_profile!.name), style: TextStyle(color: ColorsPalette.meditSea, fontSize: 40.0, fontWeight: FontWeight.w300),),
                          radius: 50.0
                      ),
                      Expanded(child: Align(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_profile!.name, style: TextStyle(fontSize: 20.0)),
                          NameEditButton(userId: _profile!.userId)
                        ],
                      ), alignment: Alignment.center,))
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Row(children: <Widget>[
                      Text("Email: " + _profile!.email, style: TextStyle(fontSize: 15.0)),
                      _profile!.emailVerified
                          ? IconButton(icon: Icon(Icons.check, color: ColorsPalette.meditSea), tooltip: 'Verified', onPressed: () {})
                          : IconButton(icon: FaIcon(FontAwesomeIcons.exclamationCircle, color: ColorsPalette.fusionRed), tooltip: 'Not verified', onPressed: () {}),
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
                  Divider(color: ColorsPalette.meditSea),
                  _familyGroup != null ? 
                  _familyGroupWidget(_familyGroup!, _profile!.accountId, _profile!.userId): Container(),                  
                  _footer()
                ],
              ),
            )
          );
        }else return loadingWidget(ColorsPalette.meditSea);
      },
    ),
    );    
  }

  Widget _familyGroupWidget(Group group, int accountId, int userId){
    group.users.removeWhere((u) => u.userId == userId);
    return Container(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,child: Text(group.name, style: TextStyle(fontSize: 20.0, color: ColorsPalette.meditSea)),
        ),
        Container(
          padding: EdgeInsets.only(right: 10.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(children: [
              group.users.length > 0 ? Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: group.users.length,
                  itemBuilder: (context, position){
                    final member = group.users[position];
                    return Slidable(key: Key(member.userId!.toString()),
                      controller: slidableController,
                      direction: Axis.horizontal,                      
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: VerticalUserListItem(group, member),
                      actions: member.accountId == null || member.accountId == accountId ? [
                        IconSlideAction(
                          color: ColorsPalette.meditSea, 
                          icon: FontAwesomeIcons.edit, 
                          onTap: () => showDialog(barrierDismissible: false, context: context,builder: (_) =>
                            BlocProvider.value(
                              value: context.read<ProfileBloc>()..add(ShowFamilyDialog()),
                              child: FamilyDialog(member, group.id!),
                            )
                        )
                        ), 
                      ] : [],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          color: ColorsPalette.carminePink, 
                          icon: FontAwesomeIcons.trashAlt, 
                          onTap: () => showDialog(barrierDismissible: false, context: context,builder: (_) =>
                            BlocProvider.value(
                              value: context.read<ProfileBloc>()..add(ShowFamilyDialog()),
                              child: UserDeleteAlert(user: member, group: group),
                            )
                        ), 
                        ), 
                      ], 
                    );
                    /*return ListTile(
                      title: Text(member.name),
                      trailing: EditFamilyButton(member, group.id!),
                    );*/
                  }),
              )
              : Container(child: Align(child: Text("No one added yet"), alignment: Alignment.centerLeft)),
                Align(
                  alignment: Alignment.centerLeft,child: AddFamilyButton(group.id!)
                ),
            ],)
          ),
        )
      ],),
    );
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
                OutlinedButton(
                  child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.signOutAlt, color: ColorsPalette.fusionRed),
                      title: Text('Sign out')),
                  onPressed: (){
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(Navigator.defaultRouteName, (Route<dynamic> route) => false);
                  },),],
            ))
      ));
  }

}