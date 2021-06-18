
import 'package:traces/helpers/api.provider.dart';
import 'package:traces/screens/notes/model/tag.model.dart';

class ApiTagsRepository{
  ApiProvider apiProvider = ApiProvider();
  String notesUrl = 'tags/';

  Future<List<Tag>> getTags( )async{
    final response = await apiProvider.getSecure(notesUrl);
      
    var notes = response["tags"] != null ? 
      response['tags'].map<Tag>((map) => Tag.fromMap(map)).toList() : null;
    return notes;
  }

}