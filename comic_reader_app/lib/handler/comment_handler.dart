import 'package:comic_reader_app/model/comment.dart';
import 'package:flutter/material.dart';

class CommentHandler extends ChangeNotifier {
  // Private list to store all comments
  List<Comment> _comments = [];

  // Getter to provide read-only access to the comments list
  List<Comment> get comments => _comments;

  // Adds a new comment to the list
  void addComment(Comment comment) {
    // Add the comment to the _comments list
    _comments.add(comment);
    // Notify listeners that the comments list has changed
    notifyListeners();
  }

  // Updates the text of an existing comment
  void updateComment(Comment targetComment, String newText) {
    // Check if the target comment is in the top-level comments list
    if (_comments.contains(targetComment)) {
      // Find the index of the target comment
      final index = _comments.indexOf(targetComment);
      // Create a copy of the target comment with the updated text
      final updatedComment = _comments[index].copyWith(text: newText);
      // Replace the old comment with the updated comment in the list
      _comments[index] = updatedComment;
      // Notify listeners that the comments list has changed
      notifyListeners();
    } else {
      // If the target comment is not in the top-level list, it's a reply comment
      // Recursively search for the target comment in the sub-comments of all comments
      _editReply(targetComment, newText, _comments);
    }
  }

  // Recursive function to update the text of a reply comment
  void _editReply(
      Comment targetComment, String newText, List<Comment> comments) {
    // Iterate through the comments list
    for (int i = 0; i < comments.length; i++) {
      // Check if the current comment is the target comment
      if (comments[i] == targetComment) {
        // Create a copy of the target comment with the updated text
        final updatedComment = comments[i].copyWith(text: newText);
        // Replace the old comment with the updated comment in the list
        comments[i] = updatedComment;
        // Notify listeners that the comments list has changed
        notifyListeners();
        // Return from the function since the comment has been found and updated
        return;
      } else {
        // If the current comment is not the target comment, recursively search in its sub-comments
        _editReply(targetComment, newText, comments[i].subComments);
      }
    }
  }

  // Deletes a comment from the list
  void deleteComment(Comment targetComment) {
    // Check if the target comment is in the top-level comments list
    if (_comments.contains(targetComment)) {
      // Remove the target comment from the list
      _comments.remove(targetComment);
      // Notify listeners that the comments list has changed
      notifyListeners();
    } else {
      // If the target comment is not in the top-level list, it's a reply comment
      // Recursively search for the target comment in the sub-comments of all comments
      _deleteReply(targetComment, _comments);
    }
  }

  // Recursive function to delete a reply comment
  void _deleteReply(Comment targetComment, List<Comment> comments) {
    // Iterate through the comments list
    for (int i = 0; i < comments.length; i++) {
      // Check if the current comment is the target comment
      if (comments[i] == targetComment) {
        // Remove the target comment from the list
        comments.removeAt(i);
        // Notify listeners that the comments list has changed
        notifyListeners();
        // Return from the function since the comment has been found and deleted
        return;
      } else {
        // If the current comment is not the target comment, recursively search in its sub-comments
        _deleteReply(targetComment, comments[i].subComments);
      }
    }
  }

  // Recursive function to add a reply comment to a parent comment
  void _addReplyToNestedComment(
      List<Comment> comments, Comment parent, Comment reply) {
    // Iterate through the comments list
    for (int i = 0; i < comments.length; i++) {
      // Check if the current comment is the parent comment
      if (comments[i].comicName == parent.comicName &&
          comments[i].updatedTime == parent.updatedTime) {
        // Add the reply comment to the sub-comments list of the parent comment
        comments[i] = comments[i]
            .copyWith(subComments: [...comments[i].subComments, reply]);
        // Notify listeners that the comments list has changed
        notifyListeners();
        // Return from the function since the reply has been added
        return;
      } else {
        // If the current comment is not the parent comment, recursively search in its sub-comments
        _addReplyToNestedComment(comments[i].subComments, parent, reply);
      }
    }
  }

  // Adds a reply comment to a parent comment
  void addReply(Comment parent, Comment reply) {
    // Call the recursive function to add the reply to the nested comment structure
    _addReplyToNestedComment(_comments, parent, reply);
  }

  // Clears all comments from the list
  void clearComments() {
    // Clear the _comments list
    _comments.clear();
    // Notify listeners that the comments list has changed
    notifyListeners();
  }

  // Sets the comments list to a new list
  void setComments(List<Comment> comments) {
    // Assign the new list to the _comments list
    _comments = comments;
    // Notify listeners that the comments list has changed
    notifyListeners();
  }

  List<Comment> getPostComments() {
    return _comments
        .where((comment) => comment.type == CommentType.post)
        .toList();
  }

  // Function to get a list of comments for comics
  List<Comment> getComicComments() {
    return _comments
        .where((comment) => comment.type == CommentType.comic)
        .toList();
  }

  // Function to get a list of comments for novels
  List<Comment> getNovelComments() {
    return _comments
        .where((comment) => comment.type == CommentType.novel)
        .toList();
  }
}
