import 'package:baseball_record/wedgets/at_bat_input_form.dart';
import 'package:flutter/material.dart';

class AtBatInputPage extends StatelessWidget {
  final int atBatIndex;

  const AtBatInputPage({super.key, required this.atBatIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('打席${atBatIndex + 1} 入力')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AtBatInputForm(
          onSubmit: (resultText) {
            Navigator.pop(context, resultText);
          },
        ),
      ),
    );
  }
}