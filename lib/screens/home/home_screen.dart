import 'package:flutter/material.dart';

import '../add_screen.dart';
import 'record_detail_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 模擬分組資料：以日期為 key，對應的工作紀錄為 value（List）
  final Map<String, List<Map<String, String>>> groupedRecords = {
    '111-06-10': [
      {'crops': '黑豆', 'task': '防病蟲害', 'field': 'D1~D3', 'note': ''},
      {'crops': '黑豆', 'task': '除草', 'field': 'D1~D3', 'note': '人工'},
      {'crops': '黑豆', 'task': '除草', 'field': 'D1~D3', 'note': '機器'},
    ],
    '111-06-01': [
      {'crops': '黃豆', 'task': '施肥', 'field': 'D1~D3', 'note': ''},
      {'crops': '黃豆', 'task': '灌溉', 'field': 'D1~D6', 'note': ''},
    ],
    '111-05-01': [
      {'crops': '黑豆', 'task': '播種', 'field': 'D1~D6', 'note': ''},
      {'crops': '黑豆', 'task': '整地', 'field': 'D1~D6', 'note': ''},
    ],
  };

  final Map<String, String> taskIcons = {
    '播種': 'assets/seed.png',
    '整地': 'assets/land.png',
    '施肥': 'assets/muck.png',
    '灌溉': 'assets/water.png',
    '除草': 'assets/grass.png',
    '防病蟲害': 'assets/worm.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('農作物紀錄'), backgroundColor: Colors.green),
      body: ListView(
        children: [
          //標題
          Container(
            color: Colors.green[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    '日期',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '農作物',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '工作項目',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '田區代號',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '備註',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          //分組資料
          ...groupedRecords.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //日期欄位
                Container(
                  color: Colors.green[200],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //每筆資料
                ...entry.value.map((record) {
                  return Material(
                    color: Colors.transparent, // 不設定會預設白底
                    child: InkWell(
                      onTap: () {
                        showRecordDetailDialog(context, record, entry.key);
                      },
                      hoverColor: Colors.green[80], // 滑鼠懸停時的顏色（Web/桌面用）
                      splashColor: Colors.green[100], // 點擊時的水波紋顏色
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            const Expanded(flex: 2, child: SizedBox()),

                            //農作物
                            Expanded(flex: 2, child: Text(record['crops'] ?? '')),

                            // 工作項目
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 30,
                                    child: FittedBox(
                                      child: Image.asset(
                                        taskIcons[record['task']] ?? 'assets/grass.png',
                                        fit: BoxFit.contain,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    record['task'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            //田區代號
                            Expanded(flex: 2, child: Text(record['field'] ?? '')),

                            //備註
                            Expanded(
                              flex: 2,
                              child: Text(record['note']!.isEmpty ? '-' : record['note']!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ],
      ),

      //新增按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordScreen()),
          );
          if (newRecord != null) {
            final date = newRecord['date']!;
            setState(() {
              groupedRecords.putIfAbsent(date, () => []);
              groupedRecords[date]!.add({
                'crops': newRecord['crops']!,
                'task': newRecord['task']!,
                'field': newRecord['field']!,
                'note': newRecord['note']!,
              });
            });
          }
        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
