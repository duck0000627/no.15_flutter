import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no15/database_helper.dart';
import 'package:no15/models/record_model.dart';
import 'package:no15/screens/muck_screen.dart';
import 'package:no15/view_models/GetxController.dart';

import 'add_screen.dart';
import '../widgets/record_detail_dialog.dart';

void printAllRecordsSimple() async {
  //看SQLite資料，debug用
  final records = await DatabaseHelper.instance.getRecords();
  records; // 一行就印出整個資料表
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 獲取controller
    final controller = Get.find<RecordController>();

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('農作物紀錄'), backgroundColor: Colors.green),
      drawer: _buildDrawer(),
      body: Obx(() {
        // 🔹 只有這裡會根據 isLoading 刷新
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: controller.groupedRecords.entries.map((entry) {
            return _buildDateGroup(context, entry.key, entry.value);
          }).toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddRecordScreen()), // 🔹 Get 路由
        child: Image.asset('assets/pen.png'),
      ),
    );
  }


  //左側選單
  Widget _buildDrawer(){
    return Drawer(
      child: Material(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text('選單')),
            ListTile(
              title: Text('農場工作紀錄'),
              onTap: () {
                Get.back(); // 🔹 返回上一頁
                Get.offAll(() => const HomeScreen()); // 🔹 返回
              },
            ),
            ListTile(
              title: Text('肥料資材使用紀錄'),
              onTap: () {
                Get.back();
                Get.to(() => const MuckScreen());
              },
            ),
          ],
        ),
      ),
    );
  }


  //農作物紀錄
  Widget _buildDateGroup(BuildContext context, String date, List<CropRecordModel> records) {
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
                  onTap: () async => showRecordDetailDialog(context, record, date),
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
                                    record.taskIcon,
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
                            record.displayNote,
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
        }),
      ],
    );
  }
}
