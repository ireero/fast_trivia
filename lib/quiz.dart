import 'package:fast_trivia/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:fast_trivia/questions_screen.dart';
import 'package:fast_trivia/results_screen.dart';
import 'package:fast_trivia/list_answers_screen.dart';
import 'package:fast_trivia/mock/api_mock.dart';
import 'package:fast_trivia/data/questions.dart';
import 'package:fast_trivia/database/database_helper.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  Future<void> loadQuizResponses() async {
    final value = await db.getAllQuizzes();
    final dynamicList = db.convertToObjectList(value);

    setState(() {
      quizResponses = dynamicList;
    });
  }

  List<String> docIDs = [];

  List<String?> selectedAnswers = [];
  List<Map<String, dynamic>> quizResponses = [];
  var activeScreen = 'start-screen';
  DatabaseHelper db = DatabaseHelper();

  void switchScreen() {
    setState(() {
      if (activeScreen == 'questions-screen') {
        activeScreen = 'results-screen';
      } else if (activeScreen == 'start-screen') {
        activeScreen = 'list-screen';
      } else if (activeScreen == 'results-screen') {
        activeScreen = 'list-screen';
      }
    });
  }

  void att(List<String?> lista) {
    selectedAnswers = lista;
  }

  saveResponse(Map<String, dynamic> t) async {
    String id = t['id'] as String;
    String name = t['name'] as String;
    List<Map<String, dynamic>> listSummary =
        (t['list_summary'] as List<dynamic>).cast<Map<String, dynamic>>();

    for (int i = 0; i < listSummary.length; i++) {
      Map<String, dynamic> summary = listSummary[i];
      Map<String, Object> response = {
        'id': id,
        'name': name,
        'user_answer': summary['user_answer'],
        'question': summary['question'],
        'question_index': summary['question_index'],
        'correct_answer': summary['correct_answer'],
      };

      db.insertQuiz(response);
      final value = await db.getAllQuizzes();
      print(value);
      setState(() {
        quizResponses = value;
      });
    }
  }

  void restartQuiz(int i) {
    setState(() {
      selectedAnswers = [];
      if (i == 0) {
        activeScreen = 'questions-screen';
      } else {
        activeScreen = 'list-screen';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fast Trivia')),
      body: _buildScreenWidget(),
      floatingActionButton: activeScreen == 'list-screen'
          ? FloatingActionButton(
              onPressed: () {
                restartQuiz(0);
              },
              backgroundColor: Colors.amber,
              child: const Text(
                'Iniciar Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  Widget _buildScreenWidget() {
    if (activeScreen == 'questions-screen') {
      return QuestionsScreen(
        change: att,
        questions: questions,
        load_result: switchScreen,
      );
    } else if (activeScreen == 'results-screen') {
      return ResultsScreen(
        saveResponse: saveResponse,
        onRestart: restartQuiz,
        chosenAnswers: selectedAnswers,
      );
    } else if (activeScreen == 'list-screen') {
      return ListAnswerScreen(
        quizResponses: quizResponses,
      );
    } else if (activeScreen == 'loading-screen') {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (activeScreen == 'start-screen') {
      return StartScreen(switchScreen);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
    loadQuizResponses();
  }

  Future<void> _fetchQuizQuestions() async {
    try {
      final fetchedQuestions = await ApiMock.fetchQuizQuestions();
      setState(() {
        activeScreen =
            'start-screen'; // Inicializa o aplicativo com a tela de listagem
        questions = fetchedQuestions;
      });
    } catch (error) {
      print('Erro ao carregar os dados do questionário: $error');
    }
  }
}
