import 'package:flutter/material.dart';

class AtBatInputForm extends StatefulWidget {
  final void Function(String result) onSubmit;

  const AtBatInputForm({super.key, required this.onSubmit});

  @override
  State<AtBatInputForm> createState() => _AtBatInputFormState();
}

class _AtBatInputFormState extends State<AtBatInputForm> {
  String? _selectedPosition;
  String? _selectedOutcome;

  final List<String> _positions = [
    '　',
    '投',
    '捕',
    '一',
    '二',
    '三',
    '遊',
    '左',
    '中',
    '右',
  ];

  final List<String> _positionIndependent = [
    '三振',
    '四球',
    '振り逃げ',
    '打撃妨害',
  ];

  final List<String> _positionDependent = [
    'ゴロ',
    '飛',
    '直',
    '安',
    '二塁打',
    '三塁打',
    '本塁打',
    '併殺',
    '犠打',
    '犠飛',
    '失策',
    '野選',
  ];

  List<String> get _outcomes {
    if (_selectedPosition == null ||
        _selectedPosition!.trim().isEmpty ||
        _selectedPosition == '　') {
      return _positionIndependent;
    } else {
      return _positionDependent;
    }
  }

  String get previewText {
    if ((_selectedOutcome == null || _selectedOutcome!.isEmpty) &&
        (_selectedPosition == null || _selectedPosition!.trim().isEmpty)) {
      return '選択してください';
    }
    if (_selectedOutcome != null && _selectedOutcome!.isNotEmpty) {
      if (_selectedPosition != null &&
          _selectedPosition!.trim().isNotEmpty &&
          _selectedPosition != '　') {
        return '${_selectedPosition!}${_selectedOutcome!}';
      } else {
        return _selectedOutcome!;
      }
    }
    return _selectedPosition ?? '';
  }

  void _submit() {
    if (previewText == '選択してください') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('守備位置か結果を選んでください')),
      );
      return;
    }

    widget.onSubmit(previewText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('守備位置を選択:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedPosition,
          hint: const Text('守備位置（任意）'),
          items: _positions.map((pos) {
            return DropdownMenuItem(
              value: pos,
              child: Text(pos),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPosition = value;
              _selectedOutcome = null;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text('結果を選択:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedOutcome,
          hint: const Text('結果を選択'),
          items: _outcomes.map((outcome) {
            return DropdownMenuItem(
              value: outcome,
              child: Text(outcome),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOutcome = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text('プレビュー:', style: TextStyle(fontSize: 18)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            previewText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('打席を記録'),
        )
      ],
    );
  }
}