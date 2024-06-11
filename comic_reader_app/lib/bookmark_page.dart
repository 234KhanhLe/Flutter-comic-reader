import 'package:comic_reader_app/chapter_detail_page.dart';
import 'package:comic_reader_app/handler/bookmark_handler.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkListPage extends StatelessWidget {
  const BookmarkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkHandler = context.watch<BookmarkHandler>();
    List<Comic> comicList = comics;
    List<Novel> novelList = novels;
    final bookmarkedChapters = bookmarkHandler.bookmarks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Chapters'),
      ),
      body: bookmarkedChapters.isEmpty
          ? const Center(child: Text('No bookmarked chapters yet.'))
          : ListView.builder(
              itemCount: bookmarkedChapters.length,
              itemBuilder: (context, index) {
                final chapter = bookmarkedChapters[index];
                final bookmarkedItemComic =
                    findItemByChapter(comicList, chapter);
                final bookmarkedItemNovel =
                    findItemByChapter(novelList, chapter);
                if (bookmarkedItemComic != null) {
                  final comic = bookmarkedItemComic;
                  final chapterIndex =
                      comic.chapters.indexWhere((c) => c.id == chapter.id);
                  return ListTile(
                      title: Text('${chapter.title} - ${comic.title}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.bookmark),
                        onPressed: () {
                          bookmarkHandler.removeBookmark(chapter);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Chapter is removed from bookmarked!'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () =>
                                    bookmarkHandler.addBookmark(chapter),
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
                              return ChapterDetailPage(
                                  item: findItemByChapter(comicList, chapter)!,
                                  chapterIndex: chapterIndex);
                            },
                          ),
                        );
                      });
                } else if (bookmarkedItemNovel != null) {
                  final novel = bookmarkedItemNovel;
                  final chapterIndex =
                      novel.chapters.indexWhere((c) => c.id == chapter.id);
                  return ListTile(
                      title: Text('${chapter.title} - ${novel.title}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.bookmark),
                        onPressed: () {
                          bookmarkHandler.removeBookmark(chapter);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Chapter is removed from bookmarked!'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () =>
                                    bookmarkHandler.addBookmark(chapter),
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
                              return ChapterDetailPage(
                                  item: findItemByChapter(novelList, chapter)!,
                                  chapterIndex: chapterIndex);
                            },
                          ),
                        );
                      });
                } else {
                  return const SizedBox();
                }
              },
            ),
    );
  }

  dynamic findItemByChapter(List<dynamic> item, Chapter chapter) {
    for (var comic in item) {
      for (var searchChapter in comic.chapters) {
        if (searchChapter.id == chapter.id) {
          return comic;
        }
      }
    }
    return null;
  }
}
