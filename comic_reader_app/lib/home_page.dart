import 'dart:js_interop';

import 'package:comic_reader_app/add_content_page.dart';
import 'package:comic_reader_app/bookmark_page.dart';
import 'package:comic_reader_app/custom_widget/chapter_reorder_widget.dart';
import 'package:comic_reader_app/custom_widget/edit_content_widget.dart';
import 'package:comic_reader_app/comic_detail_page.dart';
import 'package:comic_reader_app/favorite_page.dart';
import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/handler/favorite_handler.dart';
import 'package:comic_reader_app/login_page.dart';
import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/model/user.dart';
import 'package:comic_reader_app/novel_detail_page.dart';
import 'package:comic_reader_app/post_page.dart';
import 'package:comic_reader_app/setting_page.dart';
import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:comic_reader_app/tag_management_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String? username;

  const HomePage({super.key, this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _searchController.addListener(handleSearch);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void handleSearch() {
    setState(() {
      searchQuery = _searchController.text;
      directToTab();
    });
  }

  void directToTab() {
    if (filteredComics.isNotEmpty) {
      _tabController.animateTo(0);
    } else if (filteredNovels.isNotEmpty) {
      _tabController.animateTo(1);
    }
  }

  List<Comic> get filteredComics {
    return comics
        .where((comic) =>
            comic.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<Novel> get filteredNovels {
    return novels
        .where((novel) =>
            novel.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final authenticationHandler = context.watch<AuthenticationHandler>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeHandler(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                      directToTab();
                    });
                  },
                )
              : Text(widget.username != null
                  ? 'Welcome, ${widget.username}'
                  : 'Welcome, Guest'),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchQuery = '';
                    _searchController.clear();
                  }
                  isSearching = !isSearching;
                });
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Comics'),
              Tab(text: 'Novels'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Stack(
                    children: [
                      ComicList(comics: comics, filteredComics: filteredComics),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final newComic = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddContentPage(),
                              ),
                            );
                            if (newComic != null && newComic is Comic) {
                              setState(() {
                                comics.add(newComic);
                              });
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      NovelList(
                        novels: novels,
                        filteredNovels: filteredNovels,
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final newNovel = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddContentPage(),
                              ),
                            );
                            if (newNovel != null && newNovel is Novel) {
                              setState(() {
                                novels.add(newNovel);
                              });
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: const Text('Setting'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Bookmarked'),
                  leading: const Icon(Icons.bookmarks),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookmarkListPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Favorite'),
                  leading: const Icon(Icons.favorite_border),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Posts'),
                  leading: const Icon(Icons.post_add),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                if (authenticationHandler.user?.role == UserRole.admin)
                  ListTile(
                    title: const Text(
                      'Tag management',
                      overflow: TextOverflow.clip,
                    ),
                    leading: const Icon(Icons.tag),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TagManagementPage(
                            tags: presetTagList,
                          ),
                        ),
                      );
                    },
                  ),
                const Divider(),
                ListTile(
                  title: authenticationHandler.isLoggedIn
                      ? const Text('Logout')
                      : const Text('Login'),
                  leading: authenticationHandler.isLoggedIn
                      ? const Icon(Icons.logout)
                      : const Icon(Icons.login),
                  onTap: () {
                    if (authenticationHandler.isLoggedIn) {
                      authenticationHandler.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComicList extends StatefulWidget {
  final List<Comic> comics;
  final List<Comic> filteredComics;

  const ComicList(
      {super.key, required this.comics, required this.filteredComics});

  @override
  State<ComicList> createState() => _ComicListState();
}

class _ComicListState extends State<ComicList> {
  void showEditComicDialog(int index) {
    final comic = widget.filteredComics[index];
    final originalIndex = widget.comics.indexOf(comic);
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          item: widget.comics[index],
          onSaved: (updatedComic) {
            setState(
              () {
                widget.comics[originalIndex] = updatedComic;
                widget.filteredComics[index] = updatedComic;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteHandler = context.watch<FavoriteHandler>();
    final authenticationHandler = context.watch<AuthenticationHandler>();
    return Column(children: [
      Expanded(
          child: ListView.separated(
        itemCount: widget.filteredComics.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.filteredComics[index].title),
            subtitle: (widget.filteredComics[index].tags.isEmpty)
                ? null // Hide subtitle if there are no tags
                : Text(
                    widget.filteredComics[index].tags
                        .map((tag) => tag.name)
                        .join(', '), // Join tag names
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComicDetailPage(
                    comic: widget.filteredComics[index],
                  ),
                ),
              );
            },
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit' &&
                    authenticationHandler.isLoggedIn &&
                    authenticationHandler.user?.role == UserRole.admin) {
                  showEditComicDialog(index);
                } else if (value == 'delete' &&
                    authenticationHandler.isLoggedIn &&
                    authenticationHandler.user?.role == UserRole.admin) {
                  setState(() {
                    final originalIndex =
                        widget.comics.indexOf(widget.filteredComics[index]);
                    widget.comics.removeAt(originalIndex);
                    widget.filteredComics.removeAt(index);
                  });
                } else if (value == 'favorite') {
                  favoriteHandler
                      .addFavoriteComic(widget.filteredComics[index]);
                } else if (value == 'removeFavorite') {
                  favoriteHandler
                      .removeFavoriteComic(widget.filteredComics[index]);
                } else if (value == 'changeChapterOrders' &&
                    authenticationHandler.isLoggedIn &&
                    authenticationHandler.user?.role == UserRole.admin) {
                  openChapterReorderDialog(
                      context, widget.filteredComics[index]);
                }
              },
              itemBuilder: (context) {
                bool isFavorite = favoriteHandler
                    .isFavoriteComic(widget.filteredComics[index]);
                List<PopupMenuEntry<String>> items = [];

                if (authenticationHandler.isLoggedIn &&
                    authenticationHandler.user?.role == UserRole.admin) {
                  items.add(
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                  );
                  items.add(
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  );
                  items.add(const PopupMenuItem(
                    value: 'changeChapterOrders',
                    child: Text('Change Chapter Orders'),
                  ));
                }

                if (!isFavorite) {
                  items.add(const PopupMenuItem(
                    value: 'favorite',
                    child: Text('Add to Favorites'),
                  ));
                } else {
                  items.add(const PopupMenuItem(
                    value: 'removeFavorite',
                    child: Text('Remove from Favorites'),
                  ));
                }

                return items;
              },
            ),
          );
        },
      )),
    ]);
  }

  void openChapterReorderDialog(BuildContext context, Comic comic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChapterReorderWidget(
          chapters: comic.chapters,
          onReorder: (List<Chapter> reorderedChapters) {
            setState(() {
              comic.chapters = reorderedChapters;
            });
          },
        );
      },
    );
  }
}

class NovelList extends StatefulWidget {
  final List<Novel> novels;
  final List<Novel> filteredNovels;

  const NovelList(
      {super.key, required this.novels, required this.filteredNovels});

  @override
  State<NovelList> createState() => _NovelListState();
}

class _NovelListState extends State<NovelList> {
  void showEditNovelDialog(int index) {
    final novel = widget.filteredNovels[index];
    final originalIndex = widget.novels.indexOf(novel);
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          item: widget.novels[index],
          onSaved: (updatedNovel) {
            setState(
              () {
                widget.novels[originalIndex] = updatedNovel;
                widget.filteredNovels[index] = updatedNovel;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteHandler = context.watch<FavoriteHandler>();
    final authenticationHandler = context.watch<AuthenticationHandler>();
    return Column(children: [
      Expanded(
        child: ListView.separated(
          itemCount: widget.filteredNovels.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.filteredNovels[index].title),
              subtitle: (widget.filteredNovels[index].tags.isEmpty)
                  ? null // Hide subtitle if there are no tags
                  : Text(
                      widget.filteredNovels[index].tags
                          .map((tag) => tag.name)
                          .join(', '), // Join tag names
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailPage(
                      novel: widget.filteredNovels[index],
                    ),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit' &&
                      authenticationHandler.isLoggedIn &&
                      authenticationHandler.user?.role == UserRole.admin) {
                    showEditNovelDialog(index);
                  } else if (value == 'delete' &&
                      authenticationHandler.isLoggedIn &&
                      authenticationHandler.user?.role == UserRole.admin) {
                    setState(() {
                      final originalIndex =
                          widget.novels.indexOf(widget.filteredNovels[index]);
                      widget.novels.removeAt(originalIndex);
                      widget.filteredNovels.removeAt(index);
                    });
                  } else if (value == 'favorite') {
                    favoriteHandler
                        .addFavoriteNovel(widget.filteredNovels[index]);
                  } else if (value == 'removeFavorite') {
                    favoriteHandler
                        .removeFavoriteNovel(widget.filteredNovels[index]);
                  }
                },
                itemBuilder: (context) {
                  bool isFavorite = favoriteHandler
                      .isFavoriteNovel(widget.filteredNovels[index]);
                  List<PopupMenuEntry<String>> items = [];
                  if (authenticationHandler.isLoggedIn &&
                      authenticationHandler.user?.role == UserRole.admin) {
                    items.add(
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    );
                    items.add(
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    );
                  }
                  if (!isFavorite) {
                    items.add(const PopupMenuItem(
                      value: 'favorite',
                      child: Text('Add to Favorites'),
                    ));
                  } else {
                    items.add(const PopupMenuItem(
                      value: 'removeFavorite',
                      child: Text('Remove from Favorites'),
                    ));
                  }

                  return items;
                },
              ),
            );
          },
        ),
      ),
    ]);
  }
}
