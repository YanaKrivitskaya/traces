
import '../../../helpers/api.provider.dart';
import '../model/create_tag.model.dart';
import '../model/tag.model.dart';

class ApiTagsRepository{
  ApiProvider apiProvider = ApiProvider();
  String tagsUrl = 'tags/';

  Future<List<Tag>> getTags() async{
    final response = await apiProvider.getSecure(tagsUrl);
      
    var notes = response["tags"] != null ? 
      response['tags'].map<Tag>((map) => Tag.fromMap(map)).toList() : null;
    return notes;
  }

  Future<Tag> createTag(CreateTagModel tag) async {
    final response = await apiProvider.postSecure(tagsUrl, tag.toJson());
    
    var newTag = response["Tag"] != null ?
      Tag.fromMap(response["Tag"]) : null;
    return newTag;
  }

}