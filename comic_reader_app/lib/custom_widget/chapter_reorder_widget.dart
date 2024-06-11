import 'package:comic_reader_app/model/chapter.dart';
import 'package:flutter/material.dart';

class ChapterReorderWidget extends StatefulWidget {
  final List<Chapter> chapters;
  final void Function(List<Chapter>) onReorder;

  const ChapterReorderWidget({
    super.key,
    required this.chapters,
    required this.onReorder,
  });

  @override
  State<ChapterReorderWidget> createState() => _ChapterReorderWidgetState();
}

class _ChapterReorderWidgetState extends State<ChapterReorderWidget> {
  late List<Chapter> _reorderedChapters;
  @override
  void initState() {
    super.initState();
    _reorderedChapters = List.of(widget.chapters);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Chapter item = _reorderedChapters.removeAt(oldIndex);
      _reorderedChapters.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reorder Chapters'),
      content: SizedBox(
        width: double.maxFinite,
        child: ReorderableListView(
          shrinkWrap: true,
          onReorder: _onReorder,
          children: _reorderedChapters
              .asMap()
              .map((index, chapter) => MapEntry(
                    index,
                    ListTile(
                      key: Key('$index'),
                      title: Text(chapter.title),
                      leading: const Icon(Icons.drag_handle),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onReorder(_reorderedChapters);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex, BuildContext context) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Chapter item = widget.chapters.removeAt(oldIndex);
    widget.chapters.insert(newIndex, item);
    widget.onReorder(widget.chapters);
    Navigator.pop(context); // Close the dialog after reordering
  }
}
