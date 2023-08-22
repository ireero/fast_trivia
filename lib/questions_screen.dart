import 'package:flutter/material.dart';
import 'package:fast_trivia/radio_select.dart';
import 'package:fast_trivia/models/quiz_question.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    Key? key,
    required this.change,
    required this.load_result,
    required this.questions,
  }) : super(key: key);

  final void Function() load_result;
  final void Function(List<String?>) change;
  final List<QuizQuestion> questions;

  @override
  // ignore: library_private_types_in_public_api
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  List<String> originalAnswersOrder = [];
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _setOriginalAnswersOrder();
    _initializeSelectedAnswers();
  }

  void _setOriginalAnswersOrder() {
    originalAnswersOrder =
        List.from(widget.questions[currentQuestionIndex].shuffledAnswers);
  }

  void _initializeSelectedAnswers() {
    selectedAnswers = List.filled(widget.questions.length, null);
  }

  void _handleRadioValueChanged(String value) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = value;
    });
  }

  void _handleNextQuestion() {
    if (selectedAnswers[currentQuestionIndex] != null) {
      if (currentQuestionIndex + 1 < widget.questions.length) {
        setState(() {
          currentQuestionIndex++;
          _setOriginalAnswersOrder();
        });
      } else {
        widget.change(selectedAnswers);
        widget.load_result();
      }
    }
  }

  void _handlePreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        _setOriginalAnswersOrder();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;

    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentQuestion.text,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...originalAnswersOrder.map((answer) {
            return RadioSelect(
              answerText: answer,
              isSelected: answer == selectedAnswers[currentQuestionIndex],
              onSelectAnswer: _handleRadioValueChanged,
            );
          }).toList(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestionIndex > 0)
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: _handlePreviousQuestion,
                  child: const Text(
                    'Pergunta Anterior',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: selectedAnswers[currentQuestionIndex] != null
                    ? _handleNextQuestion
                    : null,
                child: Text(
                  isLastQuestion ? 'Finalizar' : 'Próxima Pergunta',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
