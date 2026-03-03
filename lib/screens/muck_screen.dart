import 'package:flutter/material.dart';
import 'package:no15/models/record_model.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';
import '../view_models/record_view_model.dart';
import 'add_screen.dart';
import 'home_screen.dart';

class MuckScreen extends StatefulWidget {
  const MuckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MuckScreenState();
}

class _MuckScreenState extends State<MuckScreen> {
  //APP一打開，就自動去拿最新資料
  @override
  void initState() {
    super.initState();
    // 透過 ViewModel 初始載入
    Future.microtask(() => context.read<RecordViewModel>().loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel 的變化
    final viewModel = context.watch<RecordViewModel>();

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text('肥料資材使用紀錄'),
        backgroundColor: Colors.green,
      ),
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
                  // 1. 標題列
                  _buildHeader(),

                  // 2. 分組資料 (呼叫 ViewModel 中我們剛寫好的 getter)
                  ...viewModel.groupedMuckRecords.entries.map((entry) {
                    return _buildDateGroup(entry.key, entry.value);
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
            if(context.mounted) context.read<RecordViewModel>().loadRecords(); // 重新讀取資料並更新畫面
          }
        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.green[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text('農作物', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('田區', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('資材名稱', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('施肥量', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildDateGroup(String date, List<CropRecordModel> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期欄位
        Container(
          color: Colors.green[200],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // 該日期的每筆肥料資料
        ...records.map((record) {
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.green[80],
                  splashColor: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        // 農作物
                        Expanded(flex: 2, child: Text(record.crops)),
                        // 田區代號
                        Expanded(flex: 2, child: Text(record.field)),
                        // 資材名稱
                        Expanded(flex: 2, child: Text(record.fertilizerType ?? '')),
                        // 使用量 (數字轉字串)
                        Expanded(child: Text(record.fertilizerAmount?.toString() ?? '')),
                        // 單位
                        Expanded(child: Text(record.fertilizerUnit ?? '')),
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
