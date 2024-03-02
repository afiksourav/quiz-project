import 'dart:convert';

import 'package:quiz/services/sqflitebatabase/database_helper.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqliteService {
//INSERT Invoice data
  Future<void> UserDataInsert(
    String first_name,
    String last_name,
    String email,
    String email_verified_at,
    String updated_at,
    String created_at,
    String id,
    String token,
  ) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''INSERT INTO ${SqliteHelper.UserDataTable} VALUES (
      '${first_name}',
      '${last_name}',
      '${email}',
      '${email_verified_at}',
      '${updated_at}',
      '${created_at}',
      '${id}',
      '${token}'
      )''';
    // print(query);
    try {
      var v = await db.rawInsert(query);
    } catch (e) {
      print(e);
    }
  }

  Future<void> UserDataUpdate(String email_verified_at, String id) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''UPDATE ${SqliteHelper.UserDataTable} SET
    ${SqliteHelper.email_verified_at} = '$email_verified_at'
    WHERE ${SqliteHelper.id}='$id'
    ''';
    try {
      var v = await db.rawQuery(query);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteUserData() async {
    try {
      Database db = await SqliteHelper().databaseGet;
      String popQuery = '''DELETE FROM ${SqliteHelper.UserDataTable}
        WHERE 1''';
      await db.rawQuery(popQuery);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<Map<String, Object?>>> getUserData() async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''SELECT * FROM ${SqliteHelper.UserDataTable}''';
    print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
    return v;
  }

  Future<String?> userlogInsert(String useStatus) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''INSERT INTO ${SqliteHelper.Userlog} VALUES (
      '${useStatus}'
      )''';
    // print(query);
    try {
      var v = await db.rawInsert(query);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> userlogUpdate(String userStatus) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''UPDATE ${SqliteHelper.Userlog} SET
    ${SqliteHelper.userStatus} = '$userStatus'
    ''';
    try {
      var v = await db.rawQuery(query);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, Object?>>> getUserLog() async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''SELECT * FROM ${SqliteHelper.Userlog}''';
    print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
    return v;
  }

  Future<void> quizdataInsert(
    String Q_id,
    String ans,
  ) async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''INSERT INTO ${SqliteHelper.QuizTable} VALUES (
      '${Q_id}',
      '${ans}'  
      )''';
    // print(query);
    try {
      var v = await db.rawInsert(query);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, Object?>>> getQuizData() async {
    Database db = await SqliteHelper().databaseGet;
    String query = '''SELECT * FROM ${SqliteHelper.QuizTable}''';
    print(query.toString());
    var v = await db.rawQuery(query);
    print(v.toString());
    return v;
  }

  Future<bool> deleteQuizData() async {
    try {
      Database db = await SqliteHelper().databaseGet;
      String popQuery = '''DELETE FROM ${SqliteHelper.QuizTable}
        WHERE 1''';
      await db.rawQuery(popQuery);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
