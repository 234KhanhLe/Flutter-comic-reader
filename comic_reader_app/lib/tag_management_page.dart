import 'package:comic_reader_app/custom_widget/tag_widget.dart';
import 'package:comic_reader_app/model/tag.dart';
import 'package:comic_reader_app/tag_search_page.dart';
import 'package:flutter/material.dart';

class TagManagementPage extends StatefulWidget {
  final List<Tag> tags; // List of tags

  const TagManagementPage({super.key, required this.tags});

  @override
  State<StatefulWidget> createState() {
    return TagManagementPageState();
  }
}

class TagManagementPageState extends State<TagManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tag Management'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ...widget.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          shadowColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TagSearchPage(tag: tag);
                              },
                            ),
                          );
                        },
                        onLongPress: () {
                          showTagOptions(tag);
                        },
                        child: Text(tag.name),
                      ),
                    ],
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: IconButton(
                  onPressed: () {
                    showAddNewTagDialog();
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTagOptions(Tag tag) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tag ${tag.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tag.description != null && tag.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('Description: ${tag.description}'),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showEditTagDialog(tag);
                      },
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.tags.remove(tag);
                        });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void showEditTagDialog(Tag tag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTagDialog(
          tag: tag,
          onSaved: (updatedTag) {
            setState(() {
              int index = widget.tags.indexOf(tag);
              if (index != -1) {
                widget.tags[index] = updatedTag;
              }
            });
          },
        );
      },
    );
  }

  void showAddNewTagDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddNewTagDialog(
          onSaved: (newTag) {
            setState(() {
              widget.tags.add(newTag);
            });
          },
        );
      },
    );
  }
}
