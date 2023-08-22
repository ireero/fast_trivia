import 'dart:convert';
import 'package:fast_trivia/models/quiz_question.dart';
import 'package:http/http.dart' as http;

class ApiMock {
  static Future<List<QuizQuestion>> fetchQuizQuestions() async {
    final response = await http.get(
      Uri.parse(
          'https://64e3b2e3bac46e480e791b03.mockapi.io/api/v1/questions/question_index'),
    );
    //print(response.body);
    if (response.statusCode == 200) {
      final jsonData = utf8.decode(response.bodyBytes); // Use Utf8Decoder
      final decodedData = json.decode(jsonData) as List<dynamic>;

      final quizQuestions = decodedData.map((data) {
        final text = data['text'] as String;
        final answers = (data['answers'] as List<dynamic>).cast<String>();
        return QuizQuestion(text, answers);
      }).toList();
      return quizQuestions;
    } else {
      throw Exception('Erro ao carregar os dados do questionário');
    }
  }
}
