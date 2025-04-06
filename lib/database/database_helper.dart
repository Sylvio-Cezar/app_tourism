import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/tourist_spot.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'brasatour.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        type TEXT NOT NULL,
        tags TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertFavorite(TouristSpot spot) async {
    final Database db = await database;
    await db.insert('favorites', {
      'id': spot.id,
      'name': spot.name,
      'latitude': spot.latitude,
      'longitude': spot.longitude,
      'type': spot.type,
      'tags': jsonEncode(spot.tags),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFavorite(String id) async {
    final Database db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TouristSpot>> getAllFavorites() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps
        .map(
          (map) => TouristSpot(
            id: map['id'],
            name: map['name'],
            latitude: map['latitude'],
            longitude: map['longitude'],
            type: map['type'],
            tags: Map<String, String>.from(jsonDecode(map['tags'])),
          ),
        )
        .toList();
  }

  Future<bool> isFavorite(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> updateFavorite(TouristSpot spot) async {
    final Database db = await database;
    await db.update(
      'favorites',
      {
        'name': spot.name,
        'latitude': spot.latitude,
        'longitude': spot.longitude,
        'type': spot.type,
        'tags': jsonEncode(spot.tags),
      },
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  Future<TouristSpot?> getFavoriteById(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return TouristSpot(
      id: maps[0]['id'],
      name: maps[0]['name'],
      latitude: maps[0]['latitude'],
      longitude: maps[0]['longitude'],
      type: maps[0]['type'],
      tags: Map<String, String>.from(jsonDecode(maps[0]['tags'])),
    );
  }
}
