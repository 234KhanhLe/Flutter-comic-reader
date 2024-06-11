class Comment {
  String text;
  List<Comment> subComments;
  final String comicName;
  final DateTime updatedTime;
  Map<String, int> reactions;
  final String username;

  Comment({
    required this.text,
    this.subComments = const [],
    required this.comicName,
    required this.updatedTime,
    this.reactions = const {},
    required this.username,
  }) {
    reactions = Map.from(reactions);
  }

  Comment copyWith(
      {String? text,
      List<Comment>? subComments,
      String? comicName,
      DateTime? updatedTime,
      Map<String, int>? reactions,
      String? username}) {
    return Comment(
        text: text ?? this.text,
        subComments: subComments ?? this.subComments,
        comicName: comicName ?? this.comicName,
        updatedTime: updatedTime ?? this.updatedTime,
        reactions: reactions ?? Map.from(this.reactions),
        username: username ?? this.username);
  }
}
