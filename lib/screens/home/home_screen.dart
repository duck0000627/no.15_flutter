import 'package:flutter/material.dart';
import 'package:no15/database_helper.dart';

import '../add_screen.dart';
import 'record_detail_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 模擬分組資料：以日期為 key，對應的工作紀錄為 value（List）
  Map<String, List<Map<String, String>>> groupedRecords = {};

  final Map<String, String> taskIcons = {
    '播種': 'assets/seed.png',
    '整地': 'assets/land.png',
    '施肥': 'assets/muck.png',
    '灌溉': 'assets/water.png',
    '除草': 'assets/grass.png',
    '防病蟲害': 'assets/worm.png',
  };

  //APP一打開，就自動去拿最新資料
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async{
    // 從資料庫抓資料
    final records = await DatabaseHelper.instance.getRecords();

    //整理資料
    Map<String, List<Map<String, String>>> newGroupedRecords = {};

    for (var record in records) {
      final date = record['date'] as String; // 日期
      if (!newGroupedRecords.containsKey(date)) {
        newGroupedRecords[date] = [];
      }
      newGroupedRecords[date]!.add({
        'crops': record['crops'] as String,
        'task': record['task'] as String,
        'field': record['field'] as String? ?? '',
        'note': record['note'] as String? ?? '',
      });
    }

    setState(() {
      groupedRecords = newGroupedRecords; // 更新畫面
    });

  }

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
                // Expanded(
                //   flex: 2,
                //   child: Text(
                //     '日期',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
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
                            // const Expanded(flex: 2, child: SizedBox()),

                            //農作物
                            Expanded(flex: 2, child: Text(record['crops'] ?? '')),

                            // 工作項目
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 10, //圖形半徑
                                    child: FittedBox(
                                      child: Image.asset(
                                        taskIcons[record['task']] ?? 'assets/grass.png',
                                        fit: BoxFit.contain,
                                        width: 20,
                                        height: 20,
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
          final isAdd = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordScreen()),
          );
          if (isAdd == true) {
            await _loadRecords(); // 重新讀取資料並更新畫面
          }
        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
