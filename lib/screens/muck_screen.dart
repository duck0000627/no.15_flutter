import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/record_model.dart'; // 請確認路徑是否正確
import '../view_models/record_view_model.dart'; // 請確認路徑是否正確
import 'add_screen.dart';
import 'home_screen.dart';

class MuckScreen extends StatefulWidget {
  const MuckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MuckScreenState();
}

class _MuckScreenState extends State<MuckScreen> {

  @override
  void initState() {
    super.initState();
    // 【這裡不再有舊的 _loadRecords】
    // 直接透過 ViewModel 讀取最新資料
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
              const DrawerHeader(child: Text('選單')),
              ListTile(
                title: const Text('農場工作紀錄'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('肥料資材使用紀錄'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      // 根據 ViewModel 的狀態決定要顯示載入圈圈還是列表
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // 標題列
          _buildHeader(),

          // 分組資料 (呼叫 ViewModel 中已經過濾好肥料的 groupedMuckRecords)
          ...viewModel.groupedMuckRecords.entries.map((entry) {
            return _buildDateGroup(entry.key, entry.value);
          }).toList(),
        ],
      ),

      // 新增按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isAdd = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordScreen()),
          );
          if (isAdd == true) {
            // 透過 ViewModel 重新讀取資料
            if(context.mounted) context.read<RecordViewModel>().loadRecords();
          }
        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  // ==== 以下為抽離出來的 UI 方法 ====

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
        Container(
          color: Colors.green[200],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
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
                        Expanded(flex: 2, child: Text(record.crops)),
                        Expanded(flex: 2, child: Text(record.field)),
                        Expanded(flex: 2, child: Text(record.fertilizer_type ?? '')),
                        // 這裡使用 toString() 安全地將 double 轉為字串顯示
                        Expanded(child: Text(record.fertilizer_amount?.toString() ?? '')),
                        Expanded(child: Text(record.fertilizer_unit ?? '')),
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