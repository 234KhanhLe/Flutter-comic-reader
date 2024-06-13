import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/handler/comment_handler.dart';
import 'package:comic_reader_app/model/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentSection extends StatefulWidget {
  final String titleOfEverything;
  final CommentType type;

  const CommentSection(
      {super.key, required this.titleOfEverything, required this.type});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController commentController = TextEditingController();

  Comment? replyingTo;
  Comment? editingComment;
  bool isEditing = false;
  bool isReplying = false;

  @override
  Widget build(BuildContext context) {
    final commentHandler = context.watch<CommentHandler>();
    final authenticationHandler = context.watch<AuthenticationHandler>();
    void addComment() {
      if (commentController.text.isEmpty) return;

      final newComment = Comment(
        text: commentController.text,
        comicName: widget.titleOfEverything,
        type: widget.type,
        updatedTime: DateTime.now(),
        user: authenticationHandler.user!,
      );

      setState(() {
        if (isEditing && editingComment != null) {
          commentHandler.updateComment(editingComment!, commentController.text);
        } else if (isReplying && replyingTo != null) {
          commentHandler.addReply(replyingTo!, newComment);
          isReplying = false;
          replyingTo = null;
        } else {
          commentHandler.addComment(newComment);
        }

        commentController.clear();
        isEditing = false;
        editingComment = null;
      });
    }

    List<Comment> commentsListFromTypes = [];

    if (widget.type == CommentType.post) {
      commentsListFromTypes = commentHandler.getPostComments();
    }
    if (widget.type == CommentType.comic) {
      commentsListFromTypes = commentHandler.getComicComments();
    }
    if (widget.type == CommentType.novel) {
      commentsListFromTypes = commentHandler.getNovelComments();
    }

    void startReply(Comment comment) {
      setState(() {
        replyingTo = comment;
        commentController.text = '';
        isEditing = false;
        isReplying = true;
        editingComment = null;
      });
    }

    void toggleReplyMode() {
      setState(() {
        isReplying = !isReplying;
        replyingTo = isReplying ? replyingTo : null;
      });
    }

    void editComment(Comment comment) {
      setState(() {
        commentController.text = comment.text;
        replyingTo = null;
        isEditing = true;
        isReplying = false;
        editingComment = comment;
      });
    }

    void deleteComment(Comment comment) {
      commentHandler.deleteComment(comment);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final comment in commentsListFromTypes)
          CustomCommentWidget(
            comment: comment,
            onReply: startReply,
            onEdit: editComment,
            onDelete: deleteComment,
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: isReplying
                      ? 'Replying to ${replyingTo?.text ?? ''}'
                      : 'Add a comment',
                ),
              ),
            ),
            IconButton(
              onPressed: addComment,
              icon: const Icon(Icons.send),
            ),
            if (isReplying)
              IconButton(
                onPressed: toggleReplyMode,
                icon: const Icon(Icons.cancel),
              ),
          ],
        )
      ],
    );
  }
}

class CustomCommentWidget extends StatefulWidget {
  Comment comment;
  final void Function(Comment) onReply;
  final void Function(Comment) onEdit;
  final void Function(Comment) onDelete;

  CustomCommentWidget(
      {super.key,
      required this.comment,
      required this.onReply,
      required this.onEdit,
      required this.onDelete});

  @override
  State<CustomCommentWidget> createState() => CustomCommentWidgetState();
}

class CustomCommentWidgetState extends State<CustomCommentWidget> {
  bool isExpanded = true;

  Set<String> userReactions = {};

  void toggleExpandCollapse() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Map<String, int> get mostReacted {
    if (widget.comment.reactions.isEmpty) {
      return {};
    }
    final sortedReaction = widget.comment.reactions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {sortedReaction.first.key: sortedReaction.first.value};
  }

  void replyToComment() {
    widget.onReply(widget.comment);
  }

  void editComment() {
    widget.onEdit(widget.comment);
  }

  void deleteComment() {
    widget.onDelete(widget.comment);
  }

  void addReaction(String reaction) {
    setState(() {
      final reactions = Map<String, int>.from(widget.comment.reactions);
      if (userReactions.contains(reaction)) {
        userReactions.remove(reaction);
        reactions[reaction] = (reactions[reaction] ?? 1) - 1;
      } else {
        userReactions.add(reaction);
        reactions[reaction] = (reactions[reaction] ?? 0) + 1;
      }
      widget.comment = widget.comment.copyWith(reactions: reactions);
    });
  }

  void showCommentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                editComment();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                deleteComment();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: toggleExpandCollapse,
                icon: Icon(isExpanded ? Icons.remove : Icons.add),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(widget.comment.text),
                    subtitle: Text(
                      'By ${widget.comment.user.username} On ${DateFormat('yyyy-MM-dd HH:mm').format(widget.comment.updatedTime)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          editComment();
                        } else if (value == 'delete') {
                          deleteComment();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              addReaction('👍');
                            },
                            icon: Icon(
                              Icons.thumb_up,
                              color: userReactions.contains('👍')
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () => addReaction('❤️'),
                            icon: Icon(
                              Icons.favorite,
                              color: userReactions.contains('❤️')
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: replyToComment,
                            icon: const Icon(Icons.reply),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
            ],
          ),
          if (isExpanded && widget.comment.subComments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.comment.subComments.map((subComment) {
                  return CustomCommentWidget(
                    comment: subComment,
                    onReply: widget.onReply,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
