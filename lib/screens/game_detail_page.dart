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

  @override
  void initState() {
    super.initState();

    // 初期値をセット
    _rbiController.text = widget.game.runsBattedIn.toString();
    _stealSuccessController.text = widget.game.stealSuccesses.toString();
    _stealAttemptController.text = widget.game.stealAttempts.toString();
  }

  void _saveExtraStats() {
    setState(() {
      widget.game.runsBattedIn = int.tryParse(_rbiController.text) ?? 0;
      widget.game.stealSuccesses =
          int.tryParse(_stealSuccessController.text) ?? 0;
      widget.game.stealAttempts =
          int.tryParse(_stealAttemptController.text) ?? 0;
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
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('試合日: ${widget.game.date}'),
                  Text('天気: ${widget.game.weather}'),
                  Text('打席数: ${widget.game.numAtBats}'),
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
                  Text('盗塁成績: $stealDisplay'),
                ],
              ),
            ),

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
                onPressed: isAllAtBatsFilled ? _registerGame : null,
                child: const Text('試合情報を登録'),
              ),
            )
          ],
        ),
      ),
    );
  }
}