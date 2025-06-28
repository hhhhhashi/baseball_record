import 'package:flutter/material.dart';
import '../models/game.dart';
import 'at_bat_input_page.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final TextEditingController _rbiController = TextEditingController();
  final TextEditingController _stealSuccessController = TextEditingController();
  final TextEditingController _stealAttemptController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedWeather;
  final TextEditingController _numAtBatsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<String> _weatherOptions = ['晴れ', '曇り', '雨', '雪', 'その他'];


  @override
  void initState() {
    super.initState();
    // 初期値をセット
    if (widget.game.date.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.game.date);
      if (_selectedDate != null) {
        _dateController.text =
            "${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}";
      }
    }

    _selectedWeather = widget.game.weather.isEmpty ? null : widget.game.weather;
    _numAtBatsController.text = widget.game.numAtBats.toString();
    _rbiController.text = widget.game.runsBattedIn.toString();
    _stealSuccessController.text = widget.game.stealSuccesses.toString();
    _stealAttemptController.text = widget.game.stealAttempts.toString();
  }

  void _saveExtraStats() {
    setState(() {
    widget.game.date =
        _selectedDate != null
            ? "${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}"
            : '';
    widget.game.weather = _selectedWeather ?? '';
    widget.game.numAtBats =
        int.tryParse(_numAtBatsController.text) ?? 0;

    widget.game.runsBattedIn = int.tryParse(_rbiController.text) ?? 0;
    widget.game.stealSuccesses =
        int.tryParse(_stealSuccessController.text) ?? 0;
    widget.game.stealAttempts =
        int.tryParse(_stealAttemptController.text) ?? 0;

    if (widget.game.atBats.length != widget.game.numAtBats) {
      widget.game.atBats =
          List.generate(widget.game.numAtBats, (_) => AtBat());
    }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('試合情報を保存しました')),
    );
  }

  String get stealDisplay {
    if (widget.game.stealAttempts == 0) {
      return '0/0';
    } else {
      return '${widget.game.stealSuccesses}/${widget.game.stealAttempts}';
    }
  }

  bool get isAllAtBatsFilled {
    return widget.game.atBats.every((atBat) => atBat.result != null);
  }

  void _registerGame() {
    // TODO: 保存処理を書く
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('試合情報を登録しました！')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('試合詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 試合情報
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: '試合日',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _dateController.text =
                        "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedWeather,
              decoration: const InputDecoration(labelText: '天気'),
              items: _weatherOptions.map((weather) {
                return DropdownMenuItem<String>(
                  value: weather,
                  child: Text(weather),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWeather = value;
                });
              },
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _numAtBatsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '打席数'),
              onChanged: (value) {
                final numAtBats = int.tryParse(value) ?? 0;
                setState(() {
                  widget.game.numAtBats = numAtBats;
                  widget.game.atBats =
                      List.generate(numAtBats, (_) => AtBat());
                });
              },
            ),
            const SizedBox(height: 16),

            /// 打点
            TextField(
              controller: _rbiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '打点'),
            ),
            const SizedBox(height: 8),

            /// 盗塁
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stealSuccessController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: '盗塁成功数'),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('/'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _stealAttemptController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: '盗塁試行数'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('打席入力', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: widget.game.numAtBats,
                itemBuilder: (context, index) {
                  final atBat = widget.game.atBats[index];
                  return ListTile(
                    title: Text('打席${index + 1}'),
                    subtitle: Text(atBat.result ?? '未入力'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AtBatInputPage(atBatIndex: index),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            atBat.result = result;
                            atBat.dateTime = DateTime.now()
                                .toString()
                                .substring(0, 16);
                          });
                        }
                      },
                      child: const Text('入力する'),
                    ),
                  );
                },
              ),
            ),

            /// 登録ボタン（下に配置）
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 保存処理をここに書く
                  // e.g. 保存する処理
                  _saveExtraStats();
                  // 一覧に戻る
                  Navigator.pop(context, widget.game);
                },
                child: const Text('試合情報登録'),
              ),
            )
          ],
        ),
      ),
    );
  }
}