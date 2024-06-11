import 'dart:io';

import 'package:comic_reader_app/model/chapter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddChapterDialog extends StatefulWidget {
  final bool isComic;
  const AddChapterDialog({super.key, required this.isComic});

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  List<File> images = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      images.addAll(pickedFiles.map((picked) => File(picked.path)));
    });
  }

  void concatenateContent() {
    final contentBuffer = StringBuffer();
    if (_content.isNotEmpty) {
      contentBuffer.writeln(_content);
    }
    for (final image in images) {
      contentBuffer.writeln(image.path);
    }
    _content = contentBuffer.toString();
  }

  void _saveChapter() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.isComic) {
        concatenateContent();
      }
      final newChapter = Chapter(title: _title, content: _content);
      Navigator.pop(context, newChapter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Chapter'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Chapter Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chapter title';
                }
                return null;
              },
              onSaved: (value) => setState(() => _title = value!),
            ),
            const SizedBox(height: 16.0),
            if (widget.isComic) ...[
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add Images'),
              ),
              const SizedBox(height: 8),
              images.isEmpty
                  ? const Text('No images selected')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: images
                          .map(
                            (image) => Stack(
                              children: [
                                Image.file(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images.remove(image);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    )
            ] else ...[
              TextField(
                decoration: const InputDecoration(labelText: 'Chapter Content'),
                maxLines: null,
                minLines: 3,
                onChanged: (value) => _content = value,
              ),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newChapter = Chapter(title: _title, content: _content);
              Navigator.pop(context, newChapter);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
