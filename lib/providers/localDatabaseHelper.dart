import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/apis/conversation/conversationApi.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/services/locator.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as p;

part 'conversation.dart';

class LocalDataBaseHelper {
  static LocalDataBaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;
  final String userTableName = "userTable";
  final String conversationTable = "conversationTable";
  final String messageTable = "messageTable"; // Singleton Database

  LocalDataBaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory LocalDataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = LocalDataBaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
      // print("--/-- start test process --/--");

      // print("--/-- end test process --/--");
    }
    // await testProcess();
    return _database;
  }

  deleteDB() async {
    var dbPath = await getDatabasesPath();
    String path = p.join(dbPath, 'todos.db');

    await deleteDatabase(path);
    // print("path is $path");
  }

  Future<Database> initializeDatabase() async {
    //  // Get the directory path for both Android and iOS to store database.
    deleteDB();
    var dbPath = await getDatabasesPath();
    String path = p.join(dbPath, 'todos.db');
    // Open/create the database at a given path
    var todosDatabase =
        await openDatabase(path, version: 2, onCreate: _createDb);
    _database = todosDatabase;
    ChatManager manager = locator.get<ChatManager>();
    if (FirebaseManager.instance.getUID() != null) {}

    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    // print("db is created");

    List<String> userCols = UserModel.getTableMaps();
    List<String> conversationCols = Conversation.conversationTableName;
    List<String> messageCols = Messages.messageCols;

    await db.execute('CREATE TABLE ${userCols[0]}'
        '(${userCols[1]} TEXT PRIMARY KEY, '
        '${userCols[2]} TEXT, '
        '${userCols[3]} TEXT,'
        '${userCols[4]} TEXT,'
        '${userCols[5]} TEXT'
        ')');

    await db.execute(
        'CREATE TABLE ${conversationCols[0]}(${conversationCols[1]} TEXT PRIMARY KEY, '
        '${conversationCols[2]} Text, '
        '${conversationCols[3]} TEXT,'
        '${conversationCols[5]} INTEGER,'
        'lastMessage TEXT,'
        'MediationOrder TEXT,'
        ' FOREIGN KEY(${conversationCols[2]}) REFERENCES ${userCols[0]}(${userCols[1]}) )');

    await db.execute(
        'CREATE TABLE ${messageCols[0]}(${messageCols[1]} TEXT, ${messageCols[2]} TEXT,  ${messageCols[3]} TEXT, '
        '${messageCols[6]}  BOOLEAN, ${messageCols[4]} TEXT, ${messageCols[5]} TEXT,'
        'FOREIGN KEY(${messageCols[3]}) REFERENCES ${userCols[0]}(${userCols[1]}), '
        'FOREIGN KEY(${messageCols[5]}) REFERENCES ${conversationCols[0]}(${conversationCols[1]}))');

    locator.get<ChatManager>().userMap.clear();
    locator.get<ChatManager>().conversations.clear();
  }

  Future<void> insertMessage(Messages message) async {
    await _database.insert(messageTable, message.toJson());
  }

  Future<void> insertConversation(Conversation conversation) async {
    var db = await LocalDataBaseHelper().database;

    await db.insert(conversationTable, conversation.toJson());
  }

  Future<void> insertUser(UserModel user) async {
    var db = await LocalDataBaseHelper().database;
    try {
      await db.insert(userTableName, user.toJson());
    } catch (e) {}
  }

  Future<Conversation> getConversation(String id) async {
    var db = await LocalDataBaseHelper().database;

    List<Map> maps = await db.query(
      conversationTable,
      where: "conversationId = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Conversation.fromJson(maps.first);
    }
    return null;
  }

  Future<UserModel> getUser(String id) async {
    var db = await LocalDataBaseHelper().database;

    List<Map> maps = await db.query(
      userTableName,
      where: "uid = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }
}
