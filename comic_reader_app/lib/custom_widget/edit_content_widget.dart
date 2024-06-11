import 'package:comic_reader_app/custom_widget/add_tag_widget.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/model/tag.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final dynamic item;
  final Function(dynamic) onSaved;

  const EditDialog({super.key, required this.item, required this.onSaved});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _typeController = TextEditingController(text: widget.item.type);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isComic = widget.item is Comic;
    return AlertDialog(
      title: Text(isComic ? 'Edit Comic' : 'Edit Novel'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a type';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ...widget.item.tags.isEmpty
                    ? [const Text('No Tags')]
                    : widget.item.tags.map((tag) {
                        return Chip(
                          label: Text(tag.name),
                          onDeleted: () {
                            setState(() {
                              widget.item.tags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                ActionChip(
                  label: const Text('Add Tag'),
                  onPressed: () async {
                    await showAddTagDialog(context, widget.item.tags);
                    setState(() {});
                  },
                  avatar: const Icon(Icons.add),
                ),
              ],
            ),
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
              if (widget.item is Comic) {
                final updatedComic = Comic(
                  title: _titleController.text,
                  type: _typeController.text,
                  chapters: widget.item.chapters,
                  views: widget.item.views,
                  tags: widget.item.tags,
                  updatedDate: DateTime.now(),
                );
                widget.onSaved(updatedComic);
              } else if (widget.item is Novel) {
                final updateNovel = Novel(
                    title: _titleController.text,
                    type: _typeController.text,
                    chapters: widget.item.chapters,
                    views: widget.item.views,
                    tags: widget.item.tags,
                    updatedDate: DateTime.now());
                widget.onSaved(updateNovel);
              }

              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        )
      ],
    );
  }

  Future<void> showAddTagDialog(
      BuildContext context, List<Tag> initialTags) async {
    final selectedTags = await Navigator.of(context).push<List<Tag>>(
      MaterialPageRoute(
        builder: (context) => AddTagWidget(tagList: initialTags),
      ),
    );
    if (selectedTags != null) {
      setState(() {
        widget.item.tags.clear();
        widget.item.tags.addAll(selectedTags);
      });
    }
  }
}
