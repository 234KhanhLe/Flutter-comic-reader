import 'package:comic_reader_app/model/user.dart';

class Comment {
  String text;
  List<Comment> subComments;
  final String comicName;
  final CommentType type; //could be post, comic, novel
  final DateTime updatedTime;
  Map<String, int> reactions;
  final User user;

  Comment({
    required this.text,
    this.subComments = const [],
    required this.comicName,
    required this.type,
    required this.updatedTime,
    this.reactions = const {},
    required this.user,
  }) {
    reactions = Map.from(reactions);
  }

  Comment copyWith(
      {String? text,
      List<Comment>? subComments,
      String? comicName,
      CommentType? type,
      DateTime? updatedTime,
      Map<String, int>? reactions,
      User? user}) {
    return Comment(
        text: text ?? this.text,
        subComments: subComments ?? this.subComments,
        comicName: comicName ?? this.comicName,
        type: type ?? this.type,
        updatedTime: updatedTime ?? this.updatedTime,
        reactions: reactions ?? Map.from(this.reactions),
        user: user ?? this.user);
  }
}

enum CommentType { post, comic, novel }
