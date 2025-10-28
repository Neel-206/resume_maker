import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "ResumeMaker.db";
  static const _databaseVersion = 1;

  // All tables
  static const tableProfile = 'profile';
  static const tableAbout = 'about';
  static const tableAwards = 'awards';
  static const tableDeclaration = 'declaration';
  static const tableEducation = 'education';
  static const tableExperience = 'experience';
  static const tableHobbies = 'hobbies';
  static const tableLanguages = 'languages';
  static const tableProjects = 'projects';
  static const tableReferences = 'app_references'; // "REFERENCES" is a SQL keyword
  static const tableSkills = 'skills';
  static const tableSignature = 'signature';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableProfile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            phone TEXT,
            country TEXT,
            city TEXT,
            address TEXT,
            pincode TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableAbout (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            aboutText TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableAwards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            issuer TEXT,
            year TEXT,
            month TEXT,
            description TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableDeclaration (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            declarationText TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableEducation (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            school TEXT,
            field TEXT,
            degree TEXT,
            place TEXT,
            country TEXT,
            fromYear TEXT,
            toYear TEXT,
            description TEXT,
            marks TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableExperience (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            company TEXT,
            position TEXT,
            fromYear TEXT,
            fromMonth TEXT,
            toYear TEXT,
            toMonth TEXT,
            description TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableHobbies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableLanguages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            canRead INTEGER,
            canWrite INTEGER,
            canSpeak INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableProjects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            role TEXT,
            description TEXT,
            technologies TEXT,
            link TEXT,
            year TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableReferences ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, relationship TEXT, company TEXT, phone TEXT, email TEXT )
          ''');

    await db.execute('''
          CREATE TABLE $tableSkills (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            proficiency TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableSignature (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            signature BLOB
          )
          ''');
  }

  // Helper methods to insert, query, update, and delete.

  // Insert a row into the database. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}