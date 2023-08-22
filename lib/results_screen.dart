import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_trivia/database/database_helper.dart'; // Importe a classe DatabaseHelper
import 'package:fast_trivia/data/questions.dart';
import 'package:fast_trivia/questions_summary/questions_summary.dart';
import 'package:uuid/uuid.dart';

class ResultsScreen extends StatelessWidget {
  final void Function(int) onRestart;
  final void Function(Map<String, Object>) saveResponse;
  final List<String?> chosenAnswers;

  const ResultsScreen({
    required this.saveResponse,
    required this.onRestart,
    required this.chosenAnswers,
    Key? key,
  }) : super(key: key);

  Future<List<Map<String, Object>>> getSummaryData() async {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i]!
      });
    }
    final quiz = {
      'id': '1',
      'name': 'Quiz 1',
      'correct_answer': 'A',
      'user_answer': 'B',
      'question': 'Qual é a capital do Brasil?',
      'question_index': 0,
    };
    await DatabaseHelper().insertQuiz(quiz);
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object>>>(
      future: getSummaryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available.');
        } else {
          final summaryData = snapshot.data!;
          final numTotalQuestions = questions.length;
          final numCorrectQuestions = summaryData
              .where((data) => data['user_answer'] == data['correct_answer'])
              .length;

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Você respondeu $numCorrectQuestions de $numTotalQuestions perguntas corretamente!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  QuestionsSummary(summaryData: summaryData),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SaveResponseAction(
                        whatChange: 0,
                        summary: summaryData,
                        onRestart: onRestart,
                        saveResponse: saveResponse,
                      ),
                      SaveResponseAction(
                        whatChange: 1,
                        summary: summaryData,
                        onRestart: onRestart,
                        saveResponse: saveResponse,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class SaveResponseAction extends StatefulWidget {
  const SaveResponseAction({
    required this.onRestart,
    required this.saveResponse,
    required this.summary,
    required this.whatChange,
    Key? key,
  }) : super(key: key);

  final void Function(int) onRestart;
  final void Function(Map<String, Object>) saveResponse;
  final List<Map<String, Object>> summary;
  final int whatChange;

  @override
  State<SaveResponseAction> createState() {
    return _SaveResponseActionState();
  }
}

class _SaveResponseActionState extends State<SaveResponseAction> {
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    String t = uuid.v4();
    return TextButton.icon(
      icon: Icon(
        widget.whatChange == 0 ? Icons.refresh : Icons.block,
        size: 22,
        color: Colors.white,
      ),
      onPressed: () {
        widget.saveResponse({
          'id': t,
          'name': 'CheckMob Quiz .${t}',
          'list_summary': widget.summary
        });
        widget.onRestart(widget.whatChange);
      },
      style: TextButton.styleFrom(foregroundColor: Colors.black),
      label: Text(
        widget.whatChange == 0 ? 'Restart' : 'End',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
