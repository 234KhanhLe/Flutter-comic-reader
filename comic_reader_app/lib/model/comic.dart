import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/tag.dart';

class Comic {
  final String title;
  final String type;
  List<Chapter> chapters;
  final int views;
  final DateTime updatedDate;
  String? imageUrl;
  final List<Tag> tags;

  Comic({
    required this.title,
    required this.type,
    required this.chapters,
    required this.views,
    required this.updatedDate,
    this.tags = const [],
  });
}
