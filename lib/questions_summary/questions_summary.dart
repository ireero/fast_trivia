import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_trivia/questions_summary/summary_item.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary({super.key, required this.summaryData});

  final List<Map<String, dynamic>> summaryData;

  @override
  Widget build(context) {
    return Column(
      children: [
        const SizedBox(
          height: 18,
        ),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: summaryData.map((data) {
                return SummaryItem(data);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
