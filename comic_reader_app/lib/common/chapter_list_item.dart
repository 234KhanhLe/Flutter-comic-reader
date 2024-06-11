import 'package:flutter/material.dart';

class ChapterListItem extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final VoidCallback onTap;

  const ChapterListItem({
    super.key,
    required this.title,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      selected: isCurrent,
      onTap: onTap,
    );
  }
}
