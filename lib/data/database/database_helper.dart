import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/post_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('loopin.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const integerType = 'INTEGER';

    await db.execute('''
      CREATE TABLE posts (
        id $idType,
        caption $textType,
        imageUrl $textType,
        authorName $textType NOT NULL,
        authorAvatar $textType NOT NULL,
        createdAt $textType NOT NULL,
        likeCount $integerType NOT NULL DEFAULT 0,
        comments $textType,
        isLiked $integerType NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<PostModel> createPost(PostModel post) async {
    final db = await instance.database;
    final id = await db.insert('posts', post.toMap());
    return post.copyWith(id: id);
  }

  Future<List<PostModel>> getAllPosts() async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('posts', orderBy: orderBy);
    return result.map((json) => PostModel.fromMap(json)).toList();
  }

  Future<PostModel?> getPost(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'posts',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PostModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updatePost(PostModel post) async {
    final db = await instance.database;
    return db.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  Future<int> deletePost(int id) async {
    final db = await instance.database;
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<PostModel?> toggleLike(int postId) async {
    final post = await getPost(postId);
    if (post != null) {
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
      );
      await updatePost(updatedPost);
      return updatedPost;
    }
    return null;
  }

  Future<PostModel?> addComment(int postId, Comment comment) async {
    final post = await getPost(postId);
    if (post != null) {
      final updatedComments = [...post.comments, comment];
      final updatedPost = post.copyWith(comments: updatedComments);
      await updatePost(updatedPost);
      return updatedPost;
    }
    return null;
  }

  Future<int> deleteAllPosts() async {
    final db = await instance.database;
    return await db.delete('posts');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
