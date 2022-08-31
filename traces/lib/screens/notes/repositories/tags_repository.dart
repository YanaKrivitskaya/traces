
import 'package:traces/screens/notes/models/create_tag.model.dart';
import 'package:traces/screens/notes/models/tag.model.dart';

abstract class TagsRepository{
  Future<List<Tag>?> getTags();

  Future<Tag> createTag(CreateTagModel tag);

}