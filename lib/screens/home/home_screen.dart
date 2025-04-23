import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  final  List<Map<String, String>> mockRecords = const [
    {'date': '111-06-10', 'task': '防病蟲害', 'field': 'D1~D3', 'note': ''},
    {'date': '111-06-10', 'task': '除草', 'field': 'D1~D3', 'note': '人工'},
    {'date': '111-06-10', 'task': '除草', 'field': 'D1~D3', 'note': '機器'},
    {'date': '111-06-01', 'task': '施肥', 'field': 'D1~D3', 'note': ''},
    {'date': '111-06-01', 'task': '灌溉', 'field': 'D1~D6', 'note': ''},
    {'date': '111-05-01', 'task': '播種', 'field': 'D1~D6', 'note': ''},
    {'date': '111-05-01', 'task': '整地', 'field': 'D1~D6', 'note': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('農作物紀錄'),),
      body:
      ListView.builder(
        itemCount: mockRecords.length,
        itemBuilder: (context, index){
          final record = mockRecords[index];
          return ListTile(
            leading: const Icon(Icons.agriculture),
            title: Text(record['task']!),
            subtitle: Text(
                '田區：${record['field']}\n備註：${record['note']}'
            ),
            trailing: Text(record['date']!),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
    );
  }
}