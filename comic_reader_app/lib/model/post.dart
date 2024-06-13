import 'package:comic_reader_app/model/comment.dart';
import 'package:comic_reader_app/model/user.dart';

class Post {
  static int _nextId = 1;
  final int id;
  final String title;
  final String content;
  final List<Comment> comments;
  final User author;
  final DateTime createdTime;
  final DateTime updatedTime;
  Map<String, int> reactions;

  Post({
    required this.title,
    required this.content,
    this.comments = const [],
    required this.author,
    required this.createdTime,
    required this.updatedTime,
    this.reactions = const {},
  }) : id = _nextId++ {
    reactions = Map.from(reactions);
  }

  Post copyWith({
    String? title,
    String? content,
    List<Comment>? comments,
    User? author,
    DateTime? createdTime,
    DateTime? updatedTime,
    Map<String, int>? reactions,
  }) {
    return Post(
      title: title ?? this.title,
      content: content ?? this.content,
      comments: comments ?? this.comments,
      author: author ?? this.author,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      reactions: reactions ?? Map.from(this.reactions),
    );
  }
}
