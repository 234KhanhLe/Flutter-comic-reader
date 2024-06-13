import 'package:comic_reader_app/model/post.dart';
import 'package:comic_reader_app/post_detail_page.dart';
import 'package:flutter/material.dart';

class EditPostPage extends StatefulWidget {
  Post post;
  final Function(Post) onSave;

  EditPostPage({super.key, required this.post, required this.onSave});
  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController authorController;
  late DateTime createdDate;

  @override
  void initState() {
    super.initState();
    createdDate = widget.post.createdTime;
    titleController = TextEditingController(text: widget.post.title);
    contentController = TextEditingController(text: widget.post.content);
    authorController = TextEditingController(text: widget.post.author.username);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    authorController.dispose();
    super.dispose();
  }

  void savePost() {
    if (formKey.currentState!.validate()) {
      setState(() {
        widget.post = Post(
          title: titleController.text,
          content: contentController.text,
          author: widget.post.author,
          createdTime: createdDate,
          updatedTime: DateTime.now(),
        );
      });
      Navigator.pop(context);
      widget.onSave(widget.post);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostDetailPage(post: widget.post)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
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
                decoration: const InputDecoration(labelText: 'Post Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please update a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please update a author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please update content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: savePost, child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
