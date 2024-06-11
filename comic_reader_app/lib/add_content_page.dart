import 'package:comic_reader_app/custom_widget/add_chapter_widget.dart';
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/service/content_service.dart';
import 'package:flutter/material.dart';

class AddContentPage extends StatefulWidget {
  const AddContentPage({super.key});

  @override
  State<AddContentPage> createState() => _AddContentPageState();
}

class _AddContentPageState extends State<AddContentPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _type = 'Comic';
  final List<Chapter> _chapters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Comic', 'Novel'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => setState(
                  () {
                    _title = value!;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final bool isComic =
                      _type == 'Comic'; // Determine isComic based on type
                  final newChapter = await showDialog<Chapter>(
                    context: context,
                    builder: (context) => AddChapterDialog(
                      isComic: isComic, // Pass the calculated isComic value
                    ),
                  );
                  if (newChapter != null) {
                    setState(() {
                      _chapters.add(newChapter);
                    });
                  }
                },
                child: const Text('Add Chapter'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _chapters.length,
                  itemBuilder: (context, index) {
                    return ChapterListItem(
                      title: _chapters[index].title,
                      onDelete: () => _removeChapter(index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitComic(),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeChapter(int index) {
    setState(() {
      _chapters.removeAt(index);
    });
  }

  void _submitComic() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_type == 'Comic') {
        final comic = Comic(
          title: _title,
          type: _type,
          chapters: _chapters,
          views: 0,
          updatedDate: DateTime.now(),
        );

        final savedComic = await ContentService().saveComic(comic);

        if (savedComic != null) {
          Navigator.pop(context, savedComic);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comic saved successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error saving comic. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (_type == 'Novel') {
        final novel = Novel(
          title: _title,
          type: _type,
          chapters: _chapters,
          views: 0,
          updatedDate: DateTime.now(),
        );
        final savedNovel = await ContentService().saveNovel(novel);

        if (savedNovel != null) {
          Navigator.pop(context, savedNovel);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Novel saved successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error saving novel. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for the novel.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class ChapterListItem extends StatelessWidget {
  final String title;
  final Function() onDelete;

  const ChapterListItem(
      {super.key, required this.title, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
