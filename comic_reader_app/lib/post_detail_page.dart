import 'package:comic_reader_app/custom_widget/comment_widget.dart';
import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/model/comment.dart';
import 'package:comic_reader_app/model/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  Post post;

  PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  bool isCommentSectionVisible = false;
  Map<String, int> get mostReactions {
    if (widget.post.reactions.isEmpty) {
      return {};
    }
    final sortedReaction = widget.post.reactions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {sortedReaction.first.key: sortedReaction.first.value};
  }

  void toggleCommentSection() {
    setState(() {
      isCommentSectionVisible = !isCommentSectionVisible;
    });
  }

  void addReaction(String reaction) {
    setState(() {
      widget.post.reactions
          .update(reaction, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void showReactionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  addReaction('👍');
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down),
                onPressed: () {
                  addReaction('👎');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticationHandler = context.watch<AuthenticationHandler>();
    final mostReactions = widget.post.reactions.isNotEmpty
        ? (widget.post.reactions.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By ${widget.post.author.username}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(widget.post.content),
            const SizedBox(height: 20),
            const Text(
              'Comment',
              style: TextStyle(fontSize: 18),
            ),
            if (mostReactions.isNotEmpty)
              Row(
                children: mostReactions.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Text(entry.key),
                        const SizedBox(width: 4),
                        Text(entry.value.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            Row(
              children: [
                GestureDetector(
                  child: IconButton(
                    icon: const Icon(Icons.add_reaction),
                    onPressed: () => showReactionOptions(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: toggleCommentSection,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isCommentSectionVisible)
              if (authenticationHandler.isLoggedIn)
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: CommentSection(
                      titleOfEverything: widget.post.title,
                      type: CommentType.post,
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      "You need to be logged in to comment on this comic.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
