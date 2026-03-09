import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no15/models/record_model.dart';
import 'package:no15/screens/add_screen.dart';
import '../view_models/GetxController.dart';

Future<void> showRecordDetailDialog(
  BuildContext context,
  CropRecordModel record,
  String date,
) {
  return showDialog<void>(
    context: context,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.green[300],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //標題
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      color: Colors.green[900],
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        //刪除按鈕
                        IconButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('確認刪除'),
                                    content: const Text('確定要刪除這筆紀錄嗎？'),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Get.back(result: false),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Get.back(result: true),
                                        child: const Text('刪除'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              if (record.id != null) {
                                await Get.find<RecordController>()
                                    .deleteRecord(record.id!);
                              }
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.green),
                        ),
                        const SizedBox(width: 8),
                        //編輯按鈕
                        IconButton(
                          onPressed: () {
                            Get.back(); // 🔹 先關閉 Dialog 再跳轉
                            Get.to(() => AddRecordScreen(record: record));
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                //卡片內容
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 圖 + 名稱
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 30,
                            child: Image.asset(
                              record.taskIcon,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            record.task,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Text(
                            '田區：',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(record.field),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        //換行時對齊開頭
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '備註：',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //讓備註區域彈性擴展
                          Expanded(
                            child: Text(
                              record.displayNote,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
