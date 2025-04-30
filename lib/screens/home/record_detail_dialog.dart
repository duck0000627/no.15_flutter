import 'package:flutter/material.dart';
import 'home_screen.dart';

import '../../database_helper.dart';

final Map<String, String> taskIcons = {
  '播種': 'assets/seed.png',
  '整地': 'assets/land.png',
  '施肥': 'assets/muck.png',
  '灌溉': 'assets/water.png',
  '除草': 'assets/grass.png',
  '防病蟲害': 'assets/worm.png',
};

Future<bool?> showRecordDetailDialog(
  BuildContext context,
  Map<String, dynamic> record,
  String date,
) {
  return showDialog<bool>(
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: Colors.green[900],
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
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
                                            () => Navigator.pop(context, false),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text('刪除'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              final int id = int.parse(
                                record['id'],
                              ); // 需要在 record 中有 id 欄位
                              await DatabaseHelper.instance.deleteRecord(id);
                              Navigator.pop(context, true); // 關閉詳細對話框並通知外層刷新資料
                            } else {
                              print('刪除失敗');
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.green),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.edit, color: Colors.green),
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
                              taskIcons[record['task']] ?? 'assets/default.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            record['task'] ?? '',
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
                          Text(record['field'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text(
                            '備註：',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(record['note']!.isEmpty ? '-' : record['note']!),
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
