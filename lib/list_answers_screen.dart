import 'package:fast_trivia/questions_summary/questions_summary.dart';
import 'package:fast_trivia/questions_summary/summary_item.dart';
import 'package:flutter/material.dart';

class ListAnswerScreen extends StatefulWidget {
  ListAnswerScreen({required this.quizResponses, Key? key}) : super(key: key);

  final List<Map<String, dynamic>> quizResponses;

  @override
  State<ListAnswerScreen> createState() => _ListAnswerScreenState();
}

class _ListAnswerScreenState extends State<ListAnswerScreen> {
  List<Map<String, dynamic>> selectedQuizResponses =
      []; // Lista para armazenar as respostas do quiz selecionado

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: widget.quizResponses.isEmpty
          ? Center(
              child: Text(
                'Você ainda não realizou o questionário :(\nClique no botão "Iniciar Quiz" para começar!',
              ),
            )
          : ListView.builder(
              itemCount: widget.quizResponses.length,
              itemBuilder: (context, index) {
                final response = widget.quizResponses[index];

                final String name = response['name'];
                final String id = response['id'];
                final String question = response['question'];
                final String userAnswer = response['user_answer'];
                final String correctAnswer = response['correct_answer'];
                final int questionIndex = response['question_index'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Filtra as respostas do quiz selecionado
                      selectedQuizResponses = widget.quizResponses
                          .where((response) => response['id'] == id)
                          .toList();
                    });

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: QuestionsSummary(
                            summaryData: selectedQuizResponses,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome: $name'),
                          const SizedBox(height: 8),
                          Text('id: $id'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
