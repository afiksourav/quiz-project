import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqliteHelper {
  static const String UserDataTable = 'UserDataTable';
  //column
  static const String first_name = 'first_name';
  static const String last_name = 'last_name';
  static const String email = 'email';
  static const String email_verified_at = 'email_verified_at';
  static const String updated_at = 'updated_at';
  static const String created_at = 'created_at';
  static const String id = 'id';
  static const String token = 'token';

  static const String QuizTable = 'QuizTable';
  //column
  static const String q_id = 'id';
  static const String ans = 'ans';

  static const String Userlog = 'Userlog';
  //column
  static const String userStatus = 'userStatus';

  //----------------------- DB Access
  static Database? _database;

  // static final SqliteHelper instance = SqliteHelper._init();
  // SqliteHelper._init();

  Future<Database> get databaseGet async {
    if (_database != null) {
      return _database!;
    } else {
      print('#####Initial Sql');
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<void> openSqlDatabase() async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    late Database db;
    final databaseDir = await getExternalStorageDirectory();
    //Directory databaseDir = Directory('/storage/emulated/0/storage/sql_db_folder');
    // Directory databaseDir = Directory('/storage/emulated/0/Download/sql_db_folder');
    await _createFolder(databaseDir!);
    if (await databaseDir.exists()) {
      print('#####Create DB / OpenDB');
      db = await openDatabase(
        '${databaseDir.path}/quiz',
        password: '1234',
        version: 10,
        onCreate: _createTableWithDatabase,
        onUpgrade: _onUpgrade,
      );
    }
    return db;
  }

  Future<void> _createFolder(Directory dir) async {
    if (!await Permission.storage.status.isGranted) {
      await Permission.storage.request();
      if ((await dir.exists())) {
      } else {
        dir.create();

        print('#####Create Folder');
      }
    }
  }

  //update db Function

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 20) {
    //   // Add a new column (address) to the existing table (my_table)
    //   // await db.execute('ALTER TABLE $stockINOutTable ADD COLUMN address TEXT');
    //
    //   // Create the second table (another_table) if it doesn't exist
    //   await db.execute('''
    //     CREATE TABLE IF NOT EXISTS $exchangeInvoiceTable(
    //       invoiceNo TEXT,
    //       sessionId TEXT,
    //       totalSaleAmount TEXT,
    //       totalVatAmount TEXT,
    //       totalSdAmount TEXT,
    //       totalDiscountAmount TEXT,
    //       buyerMobile TEXT,
    //       bin TEXT,
    //       deviceId TEXT,
    //       onlineFlag TEXT,
    //       transactionAt TEXT,
    //       modeOfPayment TEXT,
    //       tellerUser TEXT,
    //       approvalCode TEXT,
    //       items TEXT,
    //       onlyExchangeItem TEXT,
    //       cashPay TEXT,
    //       cardPay TEXT,
    //       mfsPay TEXT,
    //       changeAmt TEXT,
    //       oldInvoiceNo TEXT
    //     )
    //   ''');
    //
    //   await db.execute('''
    //     CREATE TABLE IF NOT EXISTS $stockMovementTable(
    //       productbyName TEXT,
    //       productbyCode TEXT,
    //       productbyPrice TEXT,
    //       stockInQTY TEXT,
    //       stockSellQTY TEXT
    //     )
    //   ''');
    //
    //   await db.execute('''
    //     CREATE TABLE IF NOT EXISTS  $draftTable (
    //       draftTableColumnNo TEXT PRIMARY KEY,
    //       draftTableColumnData TEXT
    //       )
    //      ''');
    // }
  }

  void _createTableWithDatabase(db, version) async {
    print('#####Create Table');

    String UserDataTableQuery = '''CREATE TABLE $UserDataTable (
          $first_name TEXT,
          $last_name TEXT,
          $email TEXT,
          $email_verified_at TEXT,
          $updated_at TEXT,
          $created_at TEXT,
          $id TEXT PRIMARY KEY,
          $token TEXT
          )''';

    String QuizTableQuery = '''CREATE TABLE $QuizTable (
          $q_id TEXT,
          $ans TEXT      
          )''';
    String UserLogableQuery = '''CREATE TABLE $Userlog (
          $userStatus TEXT         
          )''';

    try {
      await db.execute(UserDataTableQuery);
      await db.execute(QuizTableQuery);
      await db.execute(UserLogableQuery);

      print("create edf device");
    } catch (e) {
      print(e);
    }
  }
}
