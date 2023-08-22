import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'quiz_database.db');

    final exists = await databaseExists(path);

    if (!exists) {
      print('Passou');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE Quiz(
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              correct_answer TEXT NOT NULL,
              user_answer TEXT NOT NULL,
              question TEXT NOT NULL,
              question_index INTEGER NOT NULL
            )
          ''');
        },
      );
    } else {
      print('Já existe');
      return await openDatabase(path);
    }
  }

  Future<void> insertQuiz(Map<String, dynamic> quiz) async {
    final db = await database;
    await db.insert('Quiz', quiz, conflictAlgorithm: ConflictAlgorithm.replace);
    print('Insert passou');
  }

  Future<List<Map<String, Object>>> getAllQuizzes() async {
    final db = await database;
    final rawList = await db.query('Quiz');
    final objectList = convertToDynamicList(rawList);
    return objectList;
  }

  List<Map<String, dynamic>> transformToNewFormat(
      List<Map<String, dynamic>> inputList) {
    List<Map<String, dynamic>> newList = [];

    for (var item in inputList) {
      Map<String, dynamic> newMap = {
        'id': item['id'],
        'name': item['name'],
        'list_summary': [
          {'correct_answer': item['correct_answer']},
          {'user_answer': item['user_answer']},
          {'question': item['question']},
          {'question_index': item['question_index']},
        ],
      };

      newList.add(newMap);
    }

    return newList;
  }

  List<Map<String, dynamic>> convertToObjectList(
      List<Map<String, Object>> inputList) {
    List<Map<String, dynamic>> outputList = [];
    for (var item in inputList) {
      Map<String, dynamic> convertedItem = Map<String, dynamic>.from(item);
      outputList.add(convertedItem);
    }
    return outputList;
  }

  List<Map<String, Object>> convertToDynamicList(
      List<Map<String, dynamic>> inputList) {
    List<Map<String, Object>> outputList = [];
    for (var item in inputList) {
      Map<String, Object> convertedItem = Map<String, Object>.from(item);
      outputList.add(convertedItem);
    }
    return outputList;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final quiz = {
                  'id': '1',
                  'name': 'Quiz 1',
                  'correct_answer': 'A',
                  'user_answer': 'B',
                  'question': 'Qual é a capital do Brasil?',
                  'question_index': 0,
                };
                await dbHelper.insertQuiz(quiz);
              },
              child: const Text('Inserir Quiz'),
            ),
            ElevatedButton(
              onPressed: () async {
                final quizzes = await dbHelper.getAllQuizzes();
                print('Quizzes: $quizzes');
              },
              child: const Text('Obter Todos os Quizzes'),
            ),
          ],
        ),
      ),
    );
  }
}
