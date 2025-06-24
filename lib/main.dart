import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BattingApp());
}

class BattingApp extends StatelessWidget {
  const BattingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '草野球打撃記録',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const BattingRecordPage(),
    );
  }
}

class BattingRecordPage extends StatefulWidget {
  const BattingRecordPage({super.key});

  @override
  State<BattingRecordPage> createState() => _BattingRecordPageState();
}

class _BattingRecordPageState extends State<BattingRecordPage> {
  final List<Map<String, dynamic>> _records = [];
  String? _selectedResult;
  final List<String> _results = ['ヒット', 'アウト', '三振', '四球', 'ホームラン'];

  void _addRecord() {
    if (_selectedResult == null) return;

    setState(() {
      _records.add({
        'result': _selectedResult,
        'date': DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
      });
      _selectedResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('打席記録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('結果を選択:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedResult,
              hint: const Text('選択してください'),
              items: _results.map((String result) {
                return DropdownMenuItem<String>(
                  value: result,
                  child: Text(result),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedResult = value;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addRecord,
              child: const Text('打席を記録'),
            ),
            const SizedBox(height: 24),
            const Text('記録一覧:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return ListTile(
                    title: Text(record['result']),
                    subtitle: Text(record['date']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
