import 'package:flutter/material.dart';

class RadioSelect extends StatelessWidget {
  final String answerText;
  final bool isSelected;
  final void Function(String answer) onSelectAnswer;

  const RadioSelect({
    required this.answerText,
    required this.isSelected,
    required this.onSelectAnswer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      activeColor: Colors.amber,
      title: Text(
        answerText,
        style: TextStyle(
          color:
              isSelected ? Colors.amber : Colors.white, // Defina a cor do texto
        ),
      ),
      value: answerText,
      groupValue: isSelected ? answerText : null,
      onChanged: (String? value) {
        if (value != null) {
          onSelectAnswer(value);
        }
      },
    );
  }
}
