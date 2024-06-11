import 'package:comic_reader_app/comic_detail_page.dart';
import 'package:comic_reader_app/handler/favorite_handler.dart';
import 'package:comic_reader_app/novel_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favoriteHandler = context.watch<FavoriteHandler>();
    final favoriteComics = favoriteHandler.favoriteComics;
    final favoriteNovels = favoriteHandler.favoriteNovels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: (favoriteComics.isEmpty && favoriteNovels.isEmpty)
          ? const Center(
              child: Text('No favorite comics/novels yet.'),
            )
          : ListView.builder(
              itemCount: favoriteComics.length + favoriteNovels.length,
              itemBuilder: (context, index) {
                if (index < favoriteComics.length) {
                  final comic = favoriteComics[index];
                  return ListTile(
                    title: Text(comic.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        favoriteHandler.removeFavoriteComic(comic);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Comic is removed from favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () =>
                                  favoriteHandler.addFavoriteComic(comic),
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ComicDetailPage(comic: comic);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  final novel = favoriteNovels[index];
                  return ListTile(
                    title: Text(novel.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        favoriteHandler.removeFavoriteNovel(novel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Novel is removed from favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () =>
                                  favoriteHandler.addFavoriteNovel(novel),
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NovelDetailPage(novel: novel);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
