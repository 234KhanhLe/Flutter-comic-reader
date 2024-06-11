import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/tag.dart';

class Novel {
  final String title;
  final String type;
  List<Chapter> chapters;
  final int views;
  final DateTime updatedDate;
  final List<Tag> tags;

  Novel({
    required this.title,
    required this.type,
    required this.chapters,
    required this.views,
    required this.updatedDate,
    this.tags = const [],
  });
}
