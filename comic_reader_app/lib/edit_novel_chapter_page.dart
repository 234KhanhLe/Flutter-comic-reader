import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/novel_detail_page.dart';
import 'package:flutter/material.dart';

class EditChapterPage extends StatefulWidget {
  final Novel novel;
  final int chapterIndex;
  const EditChapterPage(
      {super.key, required this.novel, required this.chapterIndex});

  @override
  State<EditChapterPage> createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    final chapter = widget.novel.chapters[widget.chapterIndex];
    titleController = TextEditingController(text: chapter.title);
    contentController = TextEditingController(text: chapter.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveChapter() {
    if (formKey.currentState!.validate()) {
      setState(() {
        widget.novel.chapters[widget.chapterIndex] = Chapter(
          title: titleController.text,
          content: contentController.text,
        );
      });

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NovelDetailPage(novel: widget.novel);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NovelDetailPage(novel: widget.novel),
            ));
          },
        ),
        title: const Text('Edit Chapter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Chapter Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: contentController,
                  maxLines: null,
                  decoration:
                      const InputDecoration(labelText: 'Chapter Content'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveChapter,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
