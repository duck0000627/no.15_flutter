import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  final  Map<String, List<Map<String, String>>> groupedRecords = {
    '111-06-10': [
      {'task': '防病蟲害', 'field': 'D1~D3', 'note': ''},
      {'task': '除草', 'field': 'D1~D3', 'note': '人工'},
      {'task': '除草', 'field': 'D1~D3', 'note': '機器'},
    ],
    '111-06-01': [
      {'task': '施肥', 'field': 'D1~D3', 'note': ''},
      {'task': '灌溉', 'field': 'D1~D6', 'note': ''},
    ],
    '111-05-01': [
      {'task': '播種', 'field': 'D1~D6', 'note': ''},
      {'task': '整地', 'field': 'D1~D6', 'note': ''},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('農作物紀錄'),),
      body:ListView(
          children: groupedRecords.entries.map((entry){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.green[200],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                ...entry.value.map((record){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: const Icon(Icons.agriculture, color: Colors.black),
                    ),

                    // 工作項目（粗體）
                    title: Text(
                      record['task']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // 田區代號與備註（多行）
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('田區代號：${record['field']}'),
                        if (record['note'] != null && record['note']!.isNotEmpty)
                          Text('備註：${record['note']}'),
                      ],
                    ),

                    // 右側箭頭圖示
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  );
                }).toList(),
              ],
            );
          }).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
    );
  }
}