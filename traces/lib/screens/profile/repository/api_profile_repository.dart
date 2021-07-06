import '../../../utils/services/api_service.dart';
import '../model/group_model.dart';
import '../model/group_user_model.dart';
import '../model/profile_model.dart';

class ApiProfileRepository{
  ApiService apiProvider = ApiService();
  String profileUrl = 'profile/';
  
  Future<Profile> getProfileWithGroups() async{
    print("getProfileWithGroups");
    final response = await apiProvider.getSecure(profileUrl);
    var profile = Profile.fromMap(response["profile"]);
    return profile;
  }

  Future<List<Group>> getGroups() async{
    print("getGroups");
    final response = await apiProvider.getSecure('${profileUrl}groups');
    var groups = response["groups"] != null ? 
      response['groups'].map<Group>((map) => Group.fromMap(map)).toList() : null;
    return groups;
  }

  Future<Group> getGroupUsers(int groupId) async{
    print("getGroupUsers");
    final response = await apiProvider.getSecure(profileUrl + 'groups/$groupId/users');
    var group = Group.fromMap(response["group"]);
    return group;
  }

  Future<GroupUser> createUser(GroupUser user, int groupId) async{
    print("createUser");
    final response = await apiProvider.postSecure(profileUrl + 'groups/$groupId/users', user.toJson());
    var groupUser = GroupUser.fromMap(response["user"]);
    return groupUser;
  }

  Future<GroupUser> updateUser(GroupUser user) async{
    print("updateUser");
    final response = await apiProvider.putSecure(profileUrl + 'user/${user.userId}', user.toJson());
    var groupUser = GroupUser.fromMap(response["user"]);
    return groupUser;
  }

  Future<Group> removeUserFromGroup(int userId, int groupId) async{
    print("removeUserFromGroup");
    final response = await apiProvider.deleteSecure(profileUrl + 'groups/$groupId/users/$userId');
    var group = Group.fromMap(response["group"]);
    return group;
  }
  
}