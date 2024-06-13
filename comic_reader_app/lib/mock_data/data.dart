// Sample Comic 1
import 'package:comic_reader_app/model/chapter.dart';
import 'package:comic_reader_app/model/comic.dart';
import 'package:comic_reader_app/model/novel.dart';
import 'package:comic_reader_app/model/post.dart';
import 'package:comic_reader_app/model/tag.dart';
import 'package:comic_reader_app/model/user.dart';

final comic1 = Comic(
  title: "Amazing Fantasy #15",
  type: "Superhero",
  chapters: [
    Chapter(title: "The Origin of Spider-Man", content: "..."),
    Chapter(title: "With Great Power...", content: "..."),
  ],
  views: 100000,
  updatedDate: DateTime.parse("2024-05-29"),
  tags: [supernatural, action, adventure, fantasy],
);

// Sample Comic 2
final comic2 = Comic(
  title: "Watchmen",
  type: "Graphic Novel",
  chapters: [
    Chapter(title: "Attempted Murder", content: "..."),
    Chapter(title: "Under the Hood", content: "..."),
    Chapter(title: "The End is Nigh", content: "..."),
  ],
  views: 50000,
  updatedDate: DateTime.parse("2024-04-12"),
  tags: [action, adventure],
);

// Sample Comic 3 (Sci-Fi)
final comic3 = Comic(
  title: "Saga, Volume 1",
  type: "Sci-Fi",
  chapters: [
    Chapter(title: "A Princess' Escape", content: "..."),
    Chapter(title: "The Will of Alana", content: "..."),
  ],
  views: 25000,
  updatedDate: DateTime.parse("2024-03-15"),
  tags: [],
);

// List of comics
final List<Comic> comics = [comic1, comic2, comic3];

const Tag action = Tag(
  name: 'Action',
);
const Tag adult = Tag(
  name: 'Adult',
);
const Tag adventure = Tag(
  name: 'Adventure',
);
const Tag anime = Tag(
  name: 'Anime',
);
const Tag isekai = Tag(
  name: 'Isekai',
);
const Tag comedy = Tag(
  name: 'Comedy',
);
const Tag comic = Tag(
  name: 'Comic',
);
const Tag cooking = Tag(
  name: 'Cooking',
);
const Tag acient = Tag(
  name: 'Acient',
);
const Tag doujinshi = Tag(
  name: 'Doujinshi',
);
const Tag drama = Tag(
  name: 'Drama',
);
const Tag danmei = Tag(
  name: 'danmei',
);
const Tag ecchi = Tag(
  name: 'Ecchi',
);
const Tag fantasy = Tag(
  name: 'Fantasy',
);
const Tag gender_bender = Tag(
  name: 'Gender Bender',
);
const Tag harem = Tag(
  name: 'Harem',
);
const Tag historical = Tag(
  name: 'Historical',
);
const Tag horror = Tag(
  name: 'Horror',
);
const Tag josei = Tag(
  name: 'Josei',
);
const Tag live_action = Tag(
  name: 'Live action',
);
const Tag manga = Tag(
  name: 'Manga',
);
const Tag manhua = Tag(
  name: 'Manhua',
);
const Tag martial_Arts = Tag(
  name: 'Martial Arts',
);
const Tag mature = Tag(
  name: 'Mature',
);
const Tag mecha = Tag(
  name: 'Mecha',
);
const Tag mystery = Tag(
  name: 'Mystery',
);
const Tag novel = Tag(
  name: 'Novel',
);
const Tag romance = Tag(
  name: 'Romance',
);
const Tag one_shot = Tag(
  name: 'One shot',
);
const Tag psychological = Tag(
  name: 'Psychological',
);
const Tag school_Life = Tag(
  name: 'School Life',
);
const Tag sci_fi = Tag(
  name: 'Sci-fi',
);
const Tag seinen = Tag(
  name: 'Seinen',
);
const Tag shoujo = Tag(
  name: 'Shoujo',
);
const Tag shoujo_Ai = Tag(
  name: 'Shoujo Ai',
);
const Tag shounen = Tag(
  name: 'Shounen',
);
const Tag shounen_Ai = Tag(
  name: 'Shounen Ai',
);
const Tag slice = Tag(
  name: 'Slice',
);
const Tag smut = Tag(
  name: 'Smut',
);
const Tag soft_Yaoi = Tag(
  name: 'Soft Yaoi',
);
const Tag soft_Yuri = Tag(
  name: 'Soft Yuri',
);
const Tag sports = Tag(
  name: 'Sports',
);
const Tag supernatural = Tag(
  name: 'Supernatural',
);
const Tag children = Tag(
  name: 'Children',
);
const Tag tragedy = Tag(
  name: 'Tragedy',
);
const Tag detective = Tag(
  name: 'Detective',
);
const Tag ccan = Tag(
  name: 'Scan',
);
const Tag coloured = Tag(
  name: 'Coloured',
);
const Tag vietNam = Tag(
  name: 'Viet Nam',
);
const Tag webtoon = Tag(
  name: 'Webtoon',
);
const Tag time_travel = Tag(
  name: 'Time Travel',
);
const Tag sixteen = Tag(
  name: '16+',
);

final presetTagList = [
  action,
  adult,
  adventure,
  anime,
  isekai,
  comedy,
  comic,
  cooking,
  acient,
  doujinshi,
  drama,
  danmei,
  ecchi,
  fantasy,
  gender_bender,
  harem,
  historical,
  horror,
  josei,
  live_action,
  manga,
  manhua,
  martial_Arts,
  mature,
  mecha,
  mystery,
  novel,
  romance,
  one_shot,
  psychological,
  school_Life,
  sci_fi,
  seinen,
  shoujo,
  shoujo_Ai,
  shounen,
  shounen_Ai,
  slice,
  smut,
  soft_Yaoi,
  soft_Yuri,
  sports,
  supernatural,
  children,
  tragedy,
  detective,
  ccan,
  coloured,
  vietNam,
  webtoon,
  time_travel,
  sixteen
];

final novel1 = Novel(
    title: 'Novel 1',
    type: 'Detective',
    chapters: _generateChapters(10, 'Novel'),
    views: 10000,
    updatedDate: DateTime.now(),
    tags: [action]);

final novel2 = Novel(
    title: 'Novel 2',
    type: 'Romance',
    chapters: _generateChapters(50, 'Novel'),
    views: 10000,
    updatedDate: DateTime.parse("2000-01-12"),
    tags: [romance]);

final novel3 = Novel(
    title: 'Novel 3',
    type: 'Science fiction',
    chapters: _generateChapters(50, 'Novel'),
    views: 10000,
    updatedDate: DateTime.parse("1998-05-05"),
    tags: [sci_fi]);

final List<Novel> novels = [novel1, novel2, novel3];

List<Chapter> _generateChapters(int count, String type) {
  List<Chapter> chapters = [];
  for (int i = 0; i < count; i++) {
    if (type == 'Novel') {
      chapters.add(Chapter(
          title: 'Chapter $i',
          content:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"));
    } else {
      chapters.add(Chapter(title: 'Chapter $i', content: 'Content $i'));
    }
  }
  return chapters;
}

final List<Post> posts = [
  Post(
    title: "First Post",
    content: "Content 1",
    author: user1,
    createdTime: DateTime.now(),
    updatedTime: DateTime.now(),
  ),
  Post(
    title: "Second Post",
    content: "Content 2",
    author: user2,
    createdTime: DateTime.now(),
    updatedTime: DateTime.now(),
  )
];

User user1 = User(
  username: "user1",
  password: "password1",
  role: UserRole.user,
);

User user2 = User(
  username: "user2",
  password: "password2",
  role: UserRole.user,
);

User user3 = User(
  username: "user3",
  password: "password3",
  role: UserRole.user,
);

User admin1 = User(
  username: "admin1",
  password: "adminpassword1",
  role: UserRole.admin,
);

User admin2 = User(
  username: "admin2",
  password: "adminpassword2",
  role: UserRole.admin,
);

final List<User> users = [user1, user2, user3, admin1, admin2];
