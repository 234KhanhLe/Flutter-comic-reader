import 'package:comic_reader_app/custom_widget/chapter_list_widget.dart';
import 'package:comic_reader_app/comic_detail_page.dart';
import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:comic_reader_app/handler/bookmark_handler.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/novel_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterDetailPage extends StatefulWidget {
  final dynamic item;
  final int chapterIndex;

  const ChapterDetailPage(
      {super.key, required this.item, required this.chapterIndex});

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late int currentChapterIndex;

  @override
  void initState() {
    super.initState();
    currentChapterIndex = widget.chapterIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkHandler = context.watch<BookmarkHandler>();
    final fontSizeHandler = context.watch<FontSizeHandler>();
    return ChangeNotifierProvider(
      create: (_) => ThemeHandler(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Back to DetailPage
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => widget.item is Comic
                      ? ComicDetailPage(comic: widget.item)
                      : NovelDetailPage(novel: widget.item),
                ),
              );
            },
          ),
          title: Text(widget.item.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.item.chapters[currentChapterIndex].title,
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: getPreviousButton(context),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showChapterListDialog(context);
                      },
                      child: const Text(
                        'Chapters',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: getNextButton(context),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          if (bookmarkHandler.isBookmarked(
                              widget.item.chapters[currentChapterIndex])) {
                            bookmarkHandler.removeBookmark(
                                widget.item.chapters[currentChapterIndex]);
                          } else {
                            bookmarkHandler.addBookmark(
                                widget.item.chapters[currentChapterIndex]);
                          }
                        },
                        icon: Icon(
                          bookmarkHandler.isBookmarked(
                                  widget.item.chapters[currentChapterIndex])
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: bookmarkHandler.isBookmarked(
                                  widget.item.chapters[currentChapterIndex])
                              ? Colors.grey
                              : null,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.item.chapters[currentChapterIndex].content,
                      style: TextStyle(
                          fontSize: widget.item is Comic
                              ? 18.0
                              : fontSizeHandler.fontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPreviousButton(BuildContext context) {
    return IconButton(
      onPressed: currentChapterIndex > 0
          ? () => onChapterTap(context, currentChapterIndex - 1)
          : null,
      icon: const Icon(Icons.arrow_back),
      disabledColor: Colors.grey,
    );
  }

  Widget getNextButton(BuildContext context) {
    return IconButton(
      onPressed: currentChapterIndex < widget.item.chapters.length - 1
          ? () => onChapterTap(context, currentChapterIndex + 1)
          : null,
      icon: const Icon(Icons.arrow_forward),
      disabledColor: Colors.grey,
    );
  }

  void onChapterTap(BuildContext context, int index) {
    setState(() {
      currentChapterIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChapterDetailPage(item: widget.item, chapterIndex: index),
      ),
    );
  }

  void showChapterListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChapterListDialog(
          comic: widget.item,
          currentChapterIndex: currentChapterIndex,
          onChapterSelected: (int index) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChapterDetailPage(item: widget.item, chapterIndex: index),
              ),
            );
          },
        );
      },
    );
  }
}

class ChapterListView extends StatelessWidget {
  final dynamic item;
  final int currentChapter;

  const ChapterListView({
    super.key,
    required this.item,
    required this.currentChapter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: item.chapters.length,
      itemBuilder: (context, index) {
        return ChapterListItem(
          title: item.chapters[index].title,
          isCurrent: index == currentChapter,
          onTap: () => onChapterTap(context, index),
        );
      },
    );
  }

  void onChapterTap(BuildContext context, int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChapterDetailPage(item: item, chapterIndex: index),
      ),
    );
  }
}

class ChapterListItem extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final Function() onTap;

  const ChapterListItem({
    super.key,
    required this.title,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      selected: isCurrent,
      onTap: onTap,
    );
  }
}
