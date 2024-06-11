import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';

class ContentService {
  final List<Comic> _comics = [];
  final List<Novel> _novels = [];

  Future<Comic?> saveComic(Comic comic) async {
    _comics.add(comic);
    return comic;
  }

  Future<Novel?> saveNovel(Novel novel) async {
    _novels.add(novel);
    return novel;
  }
}
