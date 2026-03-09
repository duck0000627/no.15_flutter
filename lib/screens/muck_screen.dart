import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/record_model.dart'; // 請確認路徑是否正確
import '../view_models/GetxController.dart'; // 請確認路徑是否正確
import 'add_screen.dart';
import 'home_screen.dart';

class MuckScreen extends StatelessWidget {
  const MuckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 取得 Controller
    final controller = Get.find<RecordController>();

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text('肥料資材使用紀錄'),
        backgroundColor: Colors.green,
      ),
      drawer: _buildDrawer(),
      // 根據 ViewModel 的狀態決定要顯示載入圈圈還是列表
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            _buildHeader(),
            ...controller.groupedMuckRecords.entries.map((entry) {
              return _buildDateGroup(entry.key, entry.value);
            }),
          ],
        );
      }),

      // 新增按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddRecordScreen()),
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  // ==== 以下為抽離出來的 UI 方法 ====
  //表格title
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
        }),
      ],
    );
  }
}