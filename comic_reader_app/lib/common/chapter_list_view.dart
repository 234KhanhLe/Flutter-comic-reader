import 'package:comic_reader_app/common/chapter_list_item.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:flutter/material.dart';

class ChapterListView extends StatelessWidget {
  final Comic comic;
  final int currentChapter;
  final ValueChanged<int> onChapterTap;

  const ChapterListView({
    super.key,
    required this.comic,
    required this.currentChapter,
    required this.onChapterTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comic.chapters.length,
      itemBuilder: (context, index) {
        return ChapterListItem(
          title: comic.chapters[index].title,
          isCurrent: index == currentChapter,
          onTap: () => onChapterTap(index),
        );
      },
    );
  }
}
