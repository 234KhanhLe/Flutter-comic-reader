import 'package:comic_reader_app/model/chapter.dart';
import 'package:flutter/material.dart';

class BookmarkHandler extends ChangeNotifier {
  final List<Chapter> _bookmarks = [];

  List<Chapter> get bookmarks => _bookmarks;

  void addBookmark(Chapter chapter) {
    if (!_bookmarks.contains(chapter)) {
      _bookmarks.add(chapter);
    }
    notifyListeners();
  }

  void removeBookmark(Chapter chapter) {
    _bookmarks.remove(chapter);
    notifyListeners();
  }

  bool isBookmarked(Chapter chapter) {
    return _bookmarks.contains(chapter);
  }
}
