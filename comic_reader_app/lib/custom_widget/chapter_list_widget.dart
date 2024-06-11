import 'package:comic_reader_app/common/chapter_list_view.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:flutter/material.dart';

class ChapterListDialog extends StatelessWidget {
  final Comic comic;
  final int currentChapterIndex;
  final ValueChanged<int> onChapterSelected;

  const ChapterListDialog({
    super.key,
    required this.comic,
    required this.currentChapterIndex,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Chapter'),
      content: SizedBox(
        width: 400,
        child: ChapterListView(
          comic: comic,
          currentChapter: currentChapterIndex,
          onChapterTap: onChapterSelected,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
