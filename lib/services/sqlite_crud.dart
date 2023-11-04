import 'package:enotes/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future dataBase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'enotes_database.db'),
    // When the database is first created, create a table to store note.
    onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, timestamp TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  return database;
}

// Define a function that inserts note into the database
Future<void> insertNote(Note note) async {
// Get a reference to the database.
  final db = await dataBase();

// Insert the Note into the correct table. You might also specify the
// `conflictAlgorithm` to use in case the same note is inserted twice.
// In this case, replace any previous data.
  await db.insert(
    'notes',
    note.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the notes from the notes table.
Future<List<Note>> readNotes() async {
  // Get a reference to the database.
  final db = await dataBase();

  // Query the table for all The Notes.
  final List<Map<String, dynamic>> maps = await db.query('notes');

  // Convert the List<Map<String, dynamic> into a List<Note>.
  return List.generate(maps.length, (i) {
    return Note(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        content: maps[i]['content'] as String,
        timestamp: maps[i]['timestamp'] as String,
    );
  });
}

Future<void> deleteNotes(var ids) async {
  // Get a reference to the database.
  final db = await dataBase();

  // Remove the Dog from the database.
  await db.delete(
    'notes',
    // Use a `where` clause to delete a specific note.
    where: 'id IN (${List.filled(ids.length, '?').join(',')})',
    // Pass the note's id as a whereArg to prevent SQL injection.
    whereArgs: ids,
  );
}


