import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/tag.dart';
import 'package:flutter/material.dart';

class AddTagWidget extends StatefulWidget {
  final List<Tag> tagList;
  const AddTagWidget({super.key, required this.tagList});

  @override
  State<AddTagWidget> createState() => _AddTagWidgetState();
}

class _AddTagWidgetState extends State<AddTagWidget> {
  final preTagList = presetTagList;
  final selectedTags = <Tag>{};

  @override
  void initState() {
    super.initState();
    selectedTags.addAll(widget.tagList);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Tag'),
      content: SizedBox(
        width: double.maxFinite,
        height: 200,
        child: ListView(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: preTagList.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isSelected
                          ? Colors.white
                          : Colors.black, // Text color
                      backgroundColor: isSelected
                          ? Colors.blue
                          : Colors.grey, // Button color
                      shadowColor:
                          isSelected ? Colors.blueAccent : Colors.black38,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          selectedTags.remove(tag);
                        } else {
                          selectedTags.add(tag);
                        }
                      });
                    },
                    child: Text(tag.name),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.tagList.clear();
              widget.tagList.addAll(selectedTags);
            });
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
