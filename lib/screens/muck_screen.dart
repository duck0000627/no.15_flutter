import 'package:flutter/material.dart';
import 'package:no15/widgets/record_detail_dialog.dart';

import '../database_helper.dart';
import 'add_screen.dart';
import 'home_screen.dart';

class MuckScreen extends StatefulWidget{
  const MuckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MuckScreenState();
}

class _MuckScreenState extends State<MuckScreen>{
  // 模擬分組資料：以日期為 key，對應的工作紀錄為 value（List）
  Map<String, List<Map<String, String>>> groupedRecords = {};

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
        'id': record['id'].toString(),
        'date': date,
        'crops': record['crops'] as String,
        'field': record['field'] as String? ?? '',
        'fertilizer_type': record['fertilizer_type'] as String? ?? '',
        'fertilizer_amount': record['fertilizer_amount']?.toString() ?? '',
        'fertilizer_unit': record['fertilizer_unit'] as String? ?? '',
      });
    }

    //測試用
    // print(newGroupedRecords);

    setState(() {
      groupedRecords = newGroupedRecords; // 更新畫面
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('肥料資材使用紀錄'), backgroundColor: Colors.green),
      drawer: Drawer(
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Text('選單')
              ),
              ListTile(
                title: Text('農場工作紀錄'),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('肥料資材使用紀錄'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MuckScreen()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          //標題
          Container(
            color: Colors.green[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    '農作物',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '田區',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '資材名稱',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '施肥量',
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
                      onTap: () async {
                        final isDelete = await showRecordDetailDialog(context, record, entry.key);
                        if(isDelete == true){
                          await _loadRecords();
                        }
                      },
                      hoverColor: Colors.green[80], // 滑鼠懸停時的顏色（Web/桌面用）
                      splashColor: Colors.green[100], // 點擊時的水波紋顏色
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            //農作物
                            Expanded(flex: 2, child: Text(record['crops'] ?? '')),

                            //田區代號
                            Expanded(flex: 2, child: Text(record['field'] ?? '')),

                            //資材名稱
                            Expanded(flex: 2, child: Text(record['fertilizer_type'] ?? '')),

                            //使用量
                            Expanded(child: Text(record['fertilizer_amount'] ?? '')),

                            //單位
                            Expanded(child: Text(record['fertilizer_unit'] ?? '')),

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

