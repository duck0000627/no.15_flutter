import 'package:flutter/material.dart';

final Map<String, String> taskIcons = {
  '播種': 'assets/seed.png',
  '整地': 'assets/land.png',
  '施肥': 'assets/muck.png',
  '灌溉': 'assets/water.png',
  '除草': 'assets/grass.png',
  '防病蟲害': 'assets/worm.png',
};

void showRecordDetailDialog(
  BuildContext context,
  Map<String, String> record,
  String date,
) {
  showDialog(
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
                      children: const [
                        Icon(Icons.delete, color: Colors.green),
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
                          const Text('田區：', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(record['field'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text('備註：', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
