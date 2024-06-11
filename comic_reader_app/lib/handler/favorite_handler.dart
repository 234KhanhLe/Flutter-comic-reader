import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:flutter/material.dart';

class FavoriteHandler extends ChangeNotifier {
  final List<Comic> favoriteComics = [];
  final List<Novel> favoriteNovels = [];

  void addFavoriteComic(Comic comic) {
    if (!favoriteComics.contains(comic)) {
      favoriteComics.add(comic);
    }
    notifyListeners();
  }

  void addFavoriteNovel(Novel novel) {
    if (!favoriteNovels.contains(novel)) {
      favoriteNovels.add(novel);
    }
    notifyListeners();
  }

  void removeFavoriteComic(Comic comic) {
    favoriteComics.remove(comic);
    notifyListeners();
  }

  void removeFavoriteNovel(Novel novel) {
    favoriteNovels.remove(novel);
    notifyListeners();
  }

  bool isFavoriteComic(Comic comic) => favoriteComics.contains(comic);

  bool isFavoriteNovel(Novel novel) => favoriteNovels.contains(novel);
}
