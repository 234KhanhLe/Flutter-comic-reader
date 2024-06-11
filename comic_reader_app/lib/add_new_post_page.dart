import 'package:comic_reader_app/model/post.dart';
import 'package:comic_reader_app/post_detail_page.dart';
import 'package:flutter/material.dart';

class AddNewPostPage extends StatefulWidget {
  final List<Post> posts;
  final Function(Post) onSave;
  const AddNewPostPage({super.key, required this.posts, required this.onSave});

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  String author = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
                onSaved: (value) => setState(() => title = value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: "Content"),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter content";
                  }
                  return null;
                },
                onSaved: (value) => setState(() => content = value!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: "Author"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                onSaved: (value) => setState(() => author = value!),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle creating a new Post object
                    final newPost = Post(
                      title: title,
                      content: content,
                      author: author,
                      createdTime: DateTime.now(),
                      updatedTime: DateTime.now(),
                    );
                    savePost(newPost);
                  }
                },
                child: const Text("Add Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void savePost(Post newPost) {
    widget.onSave(newPost);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post: newPost);
        },
      ),
    );
  }
}
