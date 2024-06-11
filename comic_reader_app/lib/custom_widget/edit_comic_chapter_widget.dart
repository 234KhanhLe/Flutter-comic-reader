import 'package:comic_reader_app/model/chapter.dart';
import 'package:flutter/material.dart';

class EditChapterDialog extends StatefulWidget {
  final Chapter chapter;
  final Function(Chapter) onSave;
  final VoidCallback onDelete;

  const EditChapterDialog(
      {super.key,
      required this.chapter,
      required this.onSave,
      required this.onDelete});

  @override
  State<EditChapterDialog> createState() => _EditChapterDialogState();
}

class _EditChapterDialogState extends State<EditChapterDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.chapter.title);
    _contentController = TextEditingController(text: widget.chapter.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Chapter'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some content';
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final updatedChapter = Chapter(
                title: _titleController.text,
                content: _contentController.text,
              );
              widget.onSave(updatedChapter);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            widget.onDelete();
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
