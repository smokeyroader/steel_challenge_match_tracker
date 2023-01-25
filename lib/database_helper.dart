import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
const String table1Name = 'PROD';
const String table2Name = 'LTD';
const String table3Name = 'OPN';
const String table4Name = 'SS';
const String table5Name = 'RFPI';
const String table6Name = 'RFPO';
const String table7Name = 'RFRI';
const String table8Name = 'RFRO';
const String table9Name = 'PCCI';
const String table10Name = 'PCCO';
const String table11Name = 'CO';
const String table12Name = 'ISR';
const String table13Name = 'OSR';

const String table14Name = "PRODSTR";
const String table15Name = "LTDSTR";
const String table16Name = "OPNSTR";
const String table17Name = "SSSTR";
const String table18Name = "RFPISTR";
const String table19Name = "RFPOSTR";
const String table20Name = "RFRISTR";
const String table21Name = "RFROSTR";
const String table22Name = "PCCISTR";
const String table23Name = "PCCOSTR";
const String table24Name = "COSTR";
const String table25Name = "ISRSTR";
const String table26Name = "OSRSTR";

const String columnId = '_id';
const String column5 = 'FiveToGo';
const String columnShow = 'Showdown';
const String columnSH = 'SmokeAndHope';
const String columnOL = 'OuterLimits';
const String columnAcc = 'Accelerator';
const String columnPend = 'Pendulum';
const String columnSpeed = 'SpeedOption';
const String columnRound = 'Roundabout';

const String columnBest5 = 'Best5';
const String columnBestShow = 'BestShow';
const String columnBestSH = 'BestSH';
const String columnBestOL = 'BestOL';
const String columnBestAcc = 'BestAcc';
const String columnBestPend = 'BestPend';
const String columnBestSpeed = 'BestSpeed';
const String columnBestRound = 'BestRound';

const String columnShaved = 'TimeCutToday';

const String table27Name = 'MatchRecord';
const String columnDate = 'Date';
const String columnDivision = 'Division';
const String columnMatchTime = 'Time';
const String columnClass = 'Class';

const String creationStagesTable =
    '$columnId INTEGER PRIMARY KEY,  $column5 TEXT, $columnShow TEXT, $columnSH TEXT, $columnOL TEXT, $columnAcc TEXT, $columnPend TEXT, $columnSpeed TEXT, $columnRound TEXT, $columnBest5 TEXT, $columnBestShow TEXT, $columnBestSH TEXT, $columnBestOL TEXT, $columnBestAcc TEXT, $columnBestPend TEXT, $columnBestSpeed TEXT, $columnBestRound TEXT, $columnShaved TEXT';

const String creationStringsTable =
    '$columnId INTEGER PRIMARY KEY,  $column5 TEXT, $columnShow TEXT, $columnSH TEXT, $columnOL TEXT, $columnAcc TEXT, $columnPend TEXT, $columnSpeed TEXT, $columnRound TEXT';

const String creationMatchRecord =
    '$columnDate TEXT, $columnDivision TEXT, $column5 TEXT, $columnShow TEXT, $columnSH TEXT, $columnOL TEXT, $columnAcc TEXT, $columnPend TEXT, $columnSpeed TEXT, $columnRound TEXT, $columnMatchTime TEXT, $columnClass TEXT';

// data model class
class StageTimes {
  int id;

  String fiveToGo;
  String showdown;
  String smokeAndHope;
  String outerLimits;
  String accelerator;
  String pendulum;
  String speedOption;
  String roundabout;

  String best5;
  String bestShow;
  String bestSH;
  String bestOL;
  String bestAcc;
  String bestPend;
  String bestSpeed;
  String bestRound;

  String shavedTime;

  StageTimes();

  // convenience constructor to create a StageTimes object
  StageTimes.fromMap(Map<String, dynamic> map) {
    fiveToGo = map[column5];
    showdown = map[columnShow];
    smokeAndHope = map[columnSH];
    outerLimits = map[columnOL];
    accelerator = map[columnAcc];
    pendulum = map[columnPend];
    speedOption = map[columnSpeed];
    roundabout = map[columnRound];

    best5 = map[columnBest5];
    bestShow = map[columnBestShow];
    bestSH = map[columnBestSH];
    bestOL = map[columnBestOL];
    bestAcc = map[columnBestAcc];
    bestPend = map[columnBestPend];
    bestSpeed = map[columnBestSpeed];
    bestRound = map[columnBestRound];

    shavedTime = map[columnShaved];
  }

  // convenience method to create a Map from this StageTimes object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      column5: fiveToGo,
      columnShow: showdown,
      columnSH: smokeAndHope,
      columnOL: outerLimits,
      columnAcc: accelerator,
      columnPend: pendulum,
      columnSpeed: speedOption,
      columnRound: roundabout,
      columnBest5: best5,
      columnBestShow: bestShow,
      columnBestSH: bestSH,
      columnBestOL: bestOL,
      columnBestAcc: bestAcc,
      columnBestPend: bestPend,
      columnBestSpeed: bestSpeed,
      columnBestRound: bestRound,
      columnShaved: shavedTime
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class StringTimes {
  int id;

  String fiveToGo;
  String showdown;
  String smokeAndHope;
  String outerLimits;
  String accelerator;
  String pendulum;
  String speedOption;
  String roundabout;

  StringTimes();

  // convenience constructor to create a StringTimes object
  StringTimes.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    fiveToGo = map[column5];
    showdown = map[columnShow];
    smokeAndHope = map[columnSH];
    outerLimits = map[columnOL];
    accelerator = map[columnAcc];
    pendulum = map[columnPend];
    speedOption = map[columnSpeed];
    roundabout = map[columnRound];
  }

  // convenience method to create a Map from this StringTimes object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      column5: fiveToGo,
      columnShow: showdown,
      columnSH: smokeAndHope,
      columnOL: outerLimits,
      columnAcc: accelerator,
      columnPend: pendulum,
      columnSpeed: speedOption,
      columnRound: roundabout,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = 'MatchTracker.db';
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    //Create tables for stage times
    await db.execute('CREATE TABLE $table1Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table2Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table3Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table4Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table5Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table6Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table7Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table8Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table9Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table10Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table11Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table12Name ($creationStagesTable)');
    await db.execute('CREATE TABLE $table13Name ($creationStagesTable)');

    //Create tables for best string times
    await db.execute('CREATE TABLE $table14Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table15Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table16Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table17Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table18Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table19Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table20Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table21Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table22Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table23Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table24Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table25Name ($creationStringsTable)');
    await db.execute('CREATE TABLE $table26Name ($creationStringsTable)');

    await db.execute('CREATE TABLE $table27Name($creationMatchRecord)');
  }

  // Database helper methods:

  Future<int> insertStages(String table, StageTimes stages) async {
    Database db = await database;
    int id = await db.insert(table, stages.toMap());
    return id;
  }

  Future<int> insertStrings(String table, StringTimes strings) async {
    Database db = await database;
    int id = await db.insert(table, strings.toMap());
    return id;
  }

  Future<StageTimes> queryStageTimes(String table, int row) async {
    Database db = await database;
    List<Map> maps = await db.query(table,
        columns: [
          column5,
          columnShow,
          columnSH,
          columnOL,
          columnAcc,
          columnPend,
          columnSpeed,
          columnRound,
          columnBest5,
          columnBestShow,
          columnBestSH,
          columnBestOL,
          columnBestAcc,
          columnBestPend,
          columnBestSpeed,
          columnBestRound,
          columnShaved
        ],
        where: '$columnId = ?',
        whereArgs: [row]);
    if (maps.isNotEmpty) {
      return StageTimes.fromMap(maps.first);
    }
    return null;
  }

  Future<StringTimes> queryStringTimes(String table, int row) async {
    Database db = await database;
    List<Map> maps = await db.query(table,
        columns: [
          column5,
          columnShow,
          columnSH,
          columnOL,
          columnAcc,
          columnPend,
          columnSpeed,
          columnRound,
        ],
        where: '$columnId = ?',
        whereArgs: [row]);
    if (maps.isNotEmpty) {
      return StringTimes.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getCount(String table) async {
    //database connection
    Database db = await database;
    var rowCount = await db.rawQuery('SELECT COUNT (*) from $table');

    return Sqflite.firstIntValue(rowCount);
  }
}
