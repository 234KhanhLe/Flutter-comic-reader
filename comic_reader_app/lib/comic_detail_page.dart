import 'package:comic_reader_app/chapter_detail_page.dart';
import 'package:comic_reader_app/custom_widget/add_chapter_widget.dart';
import 'package:comic_reader_app/custom_widget/chapter_reorder_widget.dart';
import 'package:comic_reader_app/custom_widget/comment_widget.dart';
import 'package:comic_reader_app/custom_widget/edit_comic_chapter_widget.dart';
import 'package:comic_reader_app/custom_widget/edit_content_widget.dart';
import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/user.dart';
import 'package:comic_reader_app/tag_search_page.dart';
import 'package:comic_reader_app/handler/bookmark_handler.dart';
import 'package:comic_reader_app/handler/favorite_handler.dart';
import 'package:comic_reader_app/home_page.dart';
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComicDetailPage extends StatefulWidget {
  Comic comic;

  ComicDetailPage({super.key, required this.comic});

  @override
  State<ComicDetailPage> createState() => ComicDetailPageState();
}

class ComicDetailPageState extends State<ComicDetailPage> {
  int? editingChapterIndex = 0;
  List<Comment> comments = [];
  bool isCommentSectionVisible = false;

  void showEditComicDialog() {
    final index = comics.indexOf(widget.comic);
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          item: comics[index],
          onSaved: (updatedComic) {
            setState(
              () {
                widget.comic = updatedComic;
                comics[index] = updatedComic;
              },
            );
          },
        );
      },
    );
  }

  void openChapterReorderDialog(BuildContext context, Comic comic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChapterReorderWidget(
          chapters: comic.chapters,
          onReorder: (List<Chapter> reorderedChapters) {
            setState(() {
              comic.chapters = reorderedChapters;
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
            // Back to DetailPage
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: Text('${widget.comic.type} Detail'),
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
                  showEditComicDialog();
                } else if (value == 'changeChapterOrders') {
                  openChapterReorderDialog(context, widget.comic);
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
            widget.comic.imageUrl != null
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.comic.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Placeholder(
                    fallbackHeight: 200,
                  ),
            const SizedBox(height: 16),
            Text(
              widget.comic.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Views: '),
                Text(widget.comic.views.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Updated Date: '),
                Expanded(
                  child: Text(
                    DateFormat('yyyy-MM-dd HH:mm')
                        .format(widget.comic.updatedDate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                ...widget.comic.tags.isEmpty
                    ? [const Text('No Tags')]
                    : widget.comic.tags
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
                height: 150,
                child: widget.comic.chapters.isEmpty
                    ? const Text('No chapters available')
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final chapter = widget.comic.chapters[index];
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
                                    context, widget.comic, index);
                              },
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    showEditChapterDialog(index);
                                  } else if (value == 'delete') {
                                    setState(() {
                                      widget.comic.chapters.removeAt(index);
                                    });
                                  } else if (value == 'bookmarked') {
                                    bookmarkHandler.addBookmark(chapter);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Comic chapter is added to bookmarked!'),
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
                                            'Comic chapter is removed from bookmarked!'),
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
                        itemCount: widget.comic.chapters.length,
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
                            isComic: true,
                          ),
                        );
                        if (newChapter != null) {
                          updateComicWithNewChapter(newChapter);
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
                                      widget.comic,
                                      widget.comic.chapters.length -
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
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    onPressed: () {
                      if (favoriteHandler.isFavoriteComic(widget.comic)) {
                        favoriteHandler.removeFavoriteComic(widget.comic);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Comic is removed from favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => favoriteHandler
                                  .addFavoriteComic(widget.comic),
                            ),
                          ),
                        );
                      } else {
                        favoriteHandler.addFavoriteComic(widget.comic);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Comic is added to favorites!'),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => favoriteHandler
                                  .removeFavoriteComic(widget.comic),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      favoriteHandler.isFavoriteComic(widget.comic)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteHandler.isFavoriteComic(widget.comic)
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
                      titleOfEverything: widget.comic.title,
                      type: CommentType.comic,
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
      BuildContext context, Comic comic, int chapterIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterDetailPage(
          item: comic,
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

  void showEditChapterDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditChapterDialog(
          chapter: widget.comic.chapters[index],
          onSave: (updatedChapter) {
            setState(
              () {
                widget.comic.chapters[index] = updatedChapter;
              },
            );
          },
          onDelete: () => setState(
            () {
              widget.comic.chapters.removeAt(index);
            },
          ),
        );
      },
    );
  }

  void updateComicWithNewChapter(Chapter newChapter) {
    setState(() {
      widget.comic.chapters.add(newChapter);
    });
  }
}
