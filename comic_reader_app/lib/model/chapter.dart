class Chapter {
  static int _nextId = 1;

  final int id;
  final String title;
  final String content;

  Chapter._internal(
      {required this.id, required this.title, required this.content});

  factory Chapter({required String title, required String content}) {
    final chapter =
        Chapter._internal(id: _nextId, title: title, content: content);
    _nextId++;
    return chapter;
  }

  List<String> getContentSegments() {
    return content.split('\n');
  }
}
