import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/auth_bloc/bloc.dart';
import '../../constants/color_constants.dart';
import '../../utils/misc/state_types.dart';
import '../../utils/style/styles.dart';
import '../../widgets/error_widgets.dart';
import '../../widgets/widgets.dart';
import 'add_family_button.dart';
import 'bloc/profile/bloc.dart';
import 'family_dialog.dart';
import 'model/group_model.dart';
import 'model/profile_model.dart';
import 'user_delete_alert.dart';
import 'vertical_user_list_item.dart';


class ProfileView extends StatefulWidget{

  ProfileView();
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>{ 
  Profile? _profile;
  Group? _familyGroup;

  void initState() {   
    super.initState(); 
  }

  // for Slidable animation
  void handleSlideIsOpenChanged(bool isOpen) { }
  void handleSlideAnimationChanged(Animation<double> slideAnimation) { }  
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state){
        if(state.status == StateStatus.Error && state.profile != null){
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
                        state.exception.toString(), style: quicksandStyle(color: ColorsPalette.lynxWhite),
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
          return Center(child: loadingWidget(ColorsPalette.juicyYellow));
        }
        if(state.status == StateStatus.Success || state.status == StateStatus.Error){
          if(state.status == StateStatus.Success){
            _profile = state.profile;
            _familyGroup = _profile!.groups?.firstWhere((g) => g.name == "Family" && g.ownerAccountId == _profile!.accountId, orElse: null);
          }          

          return Container(
            padding: EdgeInsets.all(10.0),
            child: state.profile != null ? Container(
              child: Column(
                children: <Widget>[
                  avatar(getAvatarName(_profile!.name), 50.0, ColorsPalette.juicyBlue, 40.0, null),                  
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Align(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_profile!.name, style: TextStyle(fontSize: 20.0))                          
                        ],
                      ), alignment: Alignment.center,),
                  ),                 
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Wrap(children: [                     
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                      Text(_profile!.email, style: TextStyle(fontSize: 18.0))
                    ],)
                    ],),
                  ),
                  Divider(color: ColorsPalette.juicyBlue),
                  _familyGroup != null ? 
                  _familyGroupWidget(_familyGroup!, _profile!.accountId, _profile!.userId): Container(),                  
                  _footer()
                ],
              ),
            ) : state.exception != null ? errorWidget(context, error: state.exception!) : loadingWidget(ColorsPalette.juicyYellow)
          );
        }else return loadingWidget(ColorsPalette.juicyYellow);
      },
    ),
    );    
  }

  Widget _familyGroupWidget(Group group, int accountId, int userId){
    group.users.removeWhere((u) => u.userId == userId);
    return Container(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,child: Text(group.name, style: TextStyle(fontSize: 20.0, color: ColorsPalette.black)),
        ),
        Container(
          padding: EdgeInsets.only(right: 10.0),
          height: MediaQuery.of(context).size.height * 0.3,
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
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: member.accountId == null || member.accountId == accountId ? [
                          SlidableAction(
                            backgroundColor: ColorsPalette.white, 
                            icon: Icons.edit, 
                            foregroundColor: ColorsPalette.juicyBlue,
                            onPressed: (context) => showDialog(barrierDismissible: false, context: context,builder: (_) =>
                              BlocProvider.value(
                                value: context.read<ProfileBloc>()..add(ShowFamilyDialog()),
                                child: FamilyDialog(member, group.id!),
                              )
                          )
                          ), 
                        ] : [],
                        
                      ),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            backgroundColor: ColorsPalette.white, 
                            foregroundColor: ColorsPalette.redPigment,
                            icon: FontAwesomeIcons.trashAlt, 
                            onPressed: (context) => showDialog(barrierDismissible: false, context: context,builder: (_) =>
                              BlocProvider.value(
                                value: context.read<ProfileBloc>()..add(ShowFamilyDialog()),
                                child: UserDeleteAlert(user: member, group: group),
                              )
                            ), 
                          )
                        ],
                      ),                      
                      child: VerticalUserListItem(group, member)                      
                    );                   
                  }),
              )
              : Container(child: Align(child: Text("Group is empty"), alignment: Alignment.centerLeft)),
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
                Divider(color: ColorsPalette.juicyBlue),
                OutlinedButton(
                  child: ListTile(
                      leading: Icon(Icons.logout, color: ColorsPalette.juicyOrange),
                      title: Text('Sign out')),
                  onPressed: (){
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(Navigator.defaultRouteName, (Route<dynamic> route) => false);
                  },                  
                ),],
            ))
      ));
  }

}