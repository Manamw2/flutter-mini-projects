import 'dart:io';

import 'package:favourite_places/models/favourite_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<sql.Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'favourite_places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE Places(Id TEXT PRIMARY KEY, Title TEXT, Image TEXT)');
      },
      version: 1,
    );
  }

  Future<void> getPlaces() async {
    try {
      final db = await _getDatabase();
      final data = await db.query('Places');
      final places = data
          .map((row) => Place(
              id: row['Id'] as String,
              title: row['Tittle'] as String,
              image: File(row['Image'] as String)))
          .toList();
      state = places;
    } catch (error) {
      print('Error fetching places: $error');
    }
  }

  Future<void> addPlace(Place newPlace) async {
    try {
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final imageName = path.basename(newPlace.image.path);
      final copiedImage = await newPlace.image.copy('${appDir.path}/$imageName');

      final db = await _getDatabase();
      await db.insert('Places', {
        'Id': newPlace.id,
        'Tittle': newPlace.title,
        'Image': copiedImage.path, // Use the copied image path
      });

      // Verify the insert by querying the database immediately
      final data = await db.query('Places');
      print('Current places in database: $data');

      state = [...state, Place(id: newPlace.id, title: newPlace.title, image: copiedImage)];
    } catch (error) {
      print('Error adding place: $error');
    }
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
