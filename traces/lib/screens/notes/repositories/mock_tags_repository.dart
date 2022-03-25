
import 'package:traces/screens/notes/models/tag.model.dart';
import 'package:traces/screens/notes/models/create_tag.model.dart';
import 'package:traces/screens/notes/repositories/tags_repository.dart';

class MockTagsRepository extends TagsRepository{
  @override
  Future<Tag> createTag(CreateTagModel tag) async {
    print("MockTagsRepository.createTag");
    return _getTag();
  }

  @override
  Future<List<Tag>?> getTags() async{
    print("MockTagsRepository.getTags");
    var tags = List<Tag>.empty(growable: true);

    tags.add(_getTag());
  }

  Tag _getTag(){
    return new Tag(
      id: 1,
      userId: 1,
      name: "TestTag"
    );
  }

}