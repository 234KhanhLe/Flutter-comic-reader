import 'package:comic_reader_app/chapter_detail_page.dart';
import 'package:comic_reader_app/custom_widget/add_chapter_widget.dart';
import 'package:comic_reader_app/custom_widget/chapter_reorder_widget.dart';
import 'package:comic_reader_app/custom_widget/comment_widget.dart';
import 'package:comic_reader_app/custom_widget/edit_content_widget.dart';
import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/user.dart';
import 'package:comic_reader_app/tag_search_page.dart';
import 'package:comic_reader_app/edit_novel_chapter_page.dart';
import 'package:comic_reader_app/handler/bookmark_handler.dart';
import 'package:comic_reader_app/handler/favorite_handler.dart';
import 'package:comic_reader_app/home_page.dart';
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comment.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NovelDetailPage extends StatefulWidget {
  Novel novel;

  NovelDetailPage({super.key, required this.novel});

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  List<Comment> comments = [];
  bool isCommentSectionVisible = false;

  void showEditNovelDialog() {
    final index = novels.indexOf(widget.novel);
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          item: novels[index],
          onSaved: (updatedNovel) {
            setState(
              () {
                widget.novel = updatedNovel;
                novels[index] = updatedNovel;
              },
            );
          },
        );
      },
    );
  }

  void openChapterReorderDialog(BuildContext context, Novel novel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChapterReorderWidget(
          chapters: novel.chapters,
          onReorder: (List<Chapter> reorderedChapters) {
            setState(() {
              novel.chapters = reorderedChapters;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteHandler = context.watch<FavoriteHandler>();
    final bookmarkHandler = context.watch<BookmarkHandler>();
    final authenticationHandler = context.watch<AuthenticationHandler>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: Text('${widget.novel.title} Detail'),
        actions: [
          if (authenticationHandler.isLoggedIn &&
              authenticationHandler.user?.role == UserRole.admin)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'changeChapterOrders',
                  child: Text('Change Chapter Orders'),
                )
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  showEditNovelDialog();
                } else if (value == 'changeChapterOrders') {
                  openChapterReorderDialog(context, widget.novel);
                }
              },
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.novel.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Views: '),
                Text(widget.novel.views.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Updated Date: '),
                Expanded(
                  child: Text(
                    DateFormat('yyyy-MM-dd HH:mm')
                        .format(widget.novel.updatedDate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                ...widget.novel.tags.isEmpty
                    ? [const Text('No Tags')]
                    : widget.novel.tags
                        .map(
                          (tag) => TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagSearchPage(tag: tag),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              child: Text(
                                tag.name,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 300,
                child: widget.novel.chapters.isEmpty
                    ? const Text('No chapters available')
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final chapter = widget.novel.chapters[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              title: Text(chapter.title),
                              onTap: () {
                                navigateToChapterDetail(
                                    context, widget.novel, index);
                              },
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditChapterPage(
                                          novel: widget.novel,
                                          chapterIndex: index,
                                        ),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    widget.novel.chapters.removeAt(index);
                                  } else if (value == 'bookmarked') {
                                    bookmarkHandler.addBookmark(chapter);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Novel chapter is  added to bookmarked!'),
                                        duration: const Duration(seconds: 1),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () => bookmarkHandler
                                              .removeBookmark(chapter),
                                        ),
                                      ),
                                    );
                                  } else if (value == 'removeBookmarked') {
                                    bookmarkHandler.removeBookmark(chapter);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Novel chapter is removed from bookmarked!'),
                                        duration: const Duration(seconds: 1),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () => bookmarkHandler
                                              .addBookmark(chapter),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                  if (!bookmarkHandler.isBookmarked(chapter))
                                    const PopupMenuItem(
                                      value: 'bookmarked',
                                      child: Text('Add to bookmarks'),
                                    )
                                  else
                                    const PopupMenuItem(
                                      value: 'removeBookmarked',
                                      child: Text('Remove from bookmarks'),
                                    ),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.novel.chapters.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (authenticationHandler.isLoggedIn &&
                    authenticationHandler.user?.role == UserRole.admin)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        final newChapter = await showDialog<Chapter>(
                          context: context,
                          builder: (context) => const AddChapterDialog(
                            isComic: false,
                          ),
                        );
                        if (newChapter != null) {
                          updateNovelWithNewChapter(newChapter);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Chapter "${newChapter.title}" added!'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'View',
                                  onPressed: () {
                                    navigateToChapterDetail(
                                      context,
                                      widget.novel,
                                      widget.novel.chapters.length -
                                          1, // Focus on last chapter
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Add Chapter'),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    onPressed: () {
                      if (favoriteHandler.isFavoriteNovel(widget.novel)) {
                        favoriteHandler.removeFavoriteNovel(widget.novel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Novel is removed from favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => favoriteHandler
                                  .addFavoriteNovel(widget.novel),
                            ),
                          ),
                        );
                      } else {
                        favoriteHandler.addFavoriteNovel(widget.novel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Novel is added to favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => favoriteHandler
                                  .removeFavoriteNovel(widget.novel),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      favoriteHandler.isFavoriteNovel(widget.novel)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteHandler.isFavoriteNovel(widget.novel)
                          ? Colors.red
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: toggleCommentSection,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isCommentSectionVisible)
              if (authenticationHandler.isLoggedIn)
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: CommentSection(
                      titleOfEverything: widget.novel.title,
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      "You need to be logged in to comment on this comic.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void navigateToChapterDetail(
      BuildContext context, Novel novel, int chapterIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterDetailPage(
          item: novel,
          chapterIndex: chapterIndex,
        ),
      ),
    );
  }

  void toggleCommentSection() {
    setState(() {
      isCommentSectionVisible = !isCommentSectionVisible;
    });
  }

  void updateNovelWithNewChapter(Chapter newChapter) {
    setState(() {
      widget.novel.chapters.add(newChapter);
    });
  }
}
