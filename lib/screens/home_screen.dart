import 'package:flutter/material.dart';
import 'package:no15/database_helper.dart';
import 'package:no15/models/record_model.dart';
import 'package:no15/screens/muck_screen.dart';
import 'package:no15/view_models/record_view_model.dart';
import 'package:provider/provider.dart';

import 'add_screen.dart';
import '../widgets/record_detail_dialog.dart';

void printAllRecordsSimple() async {
  //看SQLite資料
  final records = await DatabaseHelper.instance.getRecords();
  print(records); // 一行就印出整個資料表
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //APP一打開，就自動去拿最新資料
  @override
  void initState() {
    super.initState();
    // 透過 ViewModel 初始載入
    Future.microtask(() => context.read<RecordViewModel>().loadRecords());
    printAllRecordsSimple(); //看SQLite資料
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel 的變化
    final viewModel = context.watch<RecordViewModel>();

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('農作物紀錄'), backgroundColor: Colors.green),
      drawer: Drawer(
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(child: Text('選單')),
              ListTile(
                title: Text('農場工作紀錄'),
                onTap: () {
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
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                children: [
                  //分組資料
                  ...viewModel.groupedRecords.entries.map((entry) {
                    return _buildDateGroup(entry.key, entry.value);
                  }),
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
            context.read<RecordViewModel>().loadRecords(); // 重新讀取資料並更新畫面
          }
        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  //農作物紀錄
  Widget _buildDateGroup(String date, List<CropRecordModel> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 顯示日期欄位 (綠底)
        Container(
          color: Colors.green[200],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 2. 顯示該日期下的每筆資料
        ...records.map((record) {
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    // 直接傳遞物件給 Dialog
                    final isChanged = await showRecordDetailDialog(
                      context,
                      record,
                      date,
                    );

                    // 再 load 一次
                    if (isChanged == true) {
                      context.read<RecordViewModel>().loadRecords();
                    }
                  },
                  hoverColor: Colors.green[80],
                  splashColor: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        // 農作物
                        Expanded(
                          flex: 2,
                          child: Text(record.crops),
                        ),

                        // 工作項目與圖示
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[100],
                                radius: 10,
                                child: FittedBox(
                                  child: Image.asset(
                                    taskIcons[record.task] ?? 'assets/grass.png',
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                record.task,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 田區代號
                        Expanded(
                          flex: 2,
                          child: Text(record.field),
                        ),

                        // 備註
                        Expanded(
                          flex: 2,
                          child: Text(
                            record.note.isEmpty ? '-' : record.note,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 2,),
            ],
          );
        }).toList(),
      ],
    );
  }
}
