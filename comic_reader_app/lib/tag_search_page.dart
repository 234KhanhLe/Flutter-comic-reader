import 'package:comic_reader_app/comic_detail_page.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/model/tag.dart';
import 'package:comic_reader_app/novel_detail_page.dart';
import 'package:flutter/material.dart';

class TagSearchPage extends StatefulWidget {
  final Tag tag;

  const TagSearchPage({super.key, required this.tag});
  @override
  State<TagSearchPage> createState() => _TagSearchPageState();
}

class _TagSearchPageState extends State<TagSearchPage> {
  List<Comic> comicsWithTag = [];
  List<Novel> novelsWithTag = [];

  @override
  void initState() {
    super.initState();
    fetchComicsAndNovelsWithTag();
  }

  void fetchComicsAndNovelsWithTag() {
    comicsWithTag = fetchComicsWithTag(widget.tag);
    novelsWithTag = fetchNovelsWithTag(widget.tag);
  }

  List<Comic> fetchComicsWithTag(Tag tag) {
    final List<Comic> comicWithTag = [];
    for (var comic in comics) {
      if (comic.tags.contains(tag)) {
        comicWithTag.add(comic);
      }
    }
    return comicWithTag;
  }

  List<Novel> fetchNovelsWithTag(Tag tag) {
    final List<Novel> novelWithTag = [];
    for (var novel in novels) {
      if (novel.tags.contains(tag)) {
        novelWithTag.add(novel);
      }
    }
    return novelWithTag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comics and Novels with "${widget.tag.name}" tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Result',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (comicsWithTag.isNotEmpty)
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: comicsWithTag.length,
                  itemBuilder: (context, index) {
                    final comic = comicsWithTag[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        title: Text(comic.title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ComicDetailPage(comic: comic),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            if (novelsWithTag.isNotEmpty)
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: novelsWithTag.length,
                  itemBuilder: (context, index) {
                    final novel = novelsWithTag[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        title: Text(novel.title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NovelDetailPage(novel: novel),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
