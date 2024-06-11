import 'package:comic_reader_app/add_new_post_page.dart';
import 'package:comic_reader_app/edit_post_page.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/post_detail_page.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => PostList();
}

class PostList extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text('By ${posts[index].author}'),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostDetailPage(post: posts[index]),
                      ),
                    );
                  },
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditPostPage(
                                post: posts[index],
                                onSave: (p0) {
                                  setState(() {
                                    posts[index] = p0;
                                  });
                                },
                              );
                            },
                          ),
                        );
                      } else if (value == 'delete') {
                        posts.removeAt(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Post'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Post'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewPostPage(
                posts: posts,
                onSave: (p0) {
                  setState(() {
                    posts.add(p0);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
