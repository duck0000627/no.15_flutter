import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no15/database_helper.dart';

class AddRecordScreen extends StatefulWidget {
  final Map<String, dynamic>? record;

  const AddRecordScreen({super.key, this.record});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _crops = '';
  String _task = '';
  String _field = '';
  String _note = '';
  DateTime _selectedDate = DateTime.now();

  final List<String> _cropsOptions = ['黃豆', '黑豆'];

  final List<String> _taskOptions = [
    '播種',
    '施肥',
    '灌溉',
    '除草',
    '整地',
    '防病蟲害',
    '採收',
    '其他',
  ];

  final List<String> _fieldOptions = ['A1', 'A2', 'A3', 'A4', 'A5', 'A6'];

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      final record = widget.record!;
      _crops = record['crops'] ?? '';
      _task = record['task'] ?? '';
      _field = record['field'] ?? '';
      _note = record['note'] ?? '';

      // 將民國格式轉回西元 DateTime
      final parts = (record['date'] as String).split('-');
      final year = int.parse(parts[0]) + 1911;
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      _selectedDate = DateTime(year, month, day);
    }
  }

  //轉換成民國
  String get formattedDate {
    return '${_selectedDate.year - 1911}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
  }

  //跳出日期選擇視窗
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.record == null ? '新增紀錄' : '編輯紀錄')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 日期選擇器
              Row(
                children: [
                  Text('日期：$formattedDate'),
                  TextButton(onPressed: _pickDate, child: const Text('選擇日期')),
                ],
              ),

              //農作物
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '農作物'),
                value: _crops.isNotEmpty ? _crops : null,
                items:
                    _cropsOptions.map((task) {
                      return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _crops = value ?? '';
                  });
                },
                onSaved: (value) => _crops = value ?? '',
              ),

              //工作項目
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '工作項目'),
                value: _task.isNotEmpty ? _task : null,
                items:
                    _taskOptions.map((task) {
                      return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _task = value ?? '';
                  });
                },
                onSaved: (value) => _task = value ?? '',
              ),
              //田區代號
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '田區代號'),
                value: _field.isNotEmpty ? _field : null,
                items:
                    _fieldOptions.map((task) {
                      return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _field = value ?? '';
                  });
                },
                onSaved: (value) => _field = value ?? '',
              ),
              //備註
              TextFormField(
                decoration: const InputDecoration(labelText: '備註'),
                initialValue: _note,
                onSaved: (value) => _note = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();

                  final newRecord = {
                    'date': formattedDate,
                    'crops': _crops,
                    'task': _task,
                    'field': _field,
                    'note': _note,
                  };

                  try {
                    if (widget.record == null) {
                      // 沒資料的話就新增，存進資料庫
                      await DatabaseHelper.instance.insertRecord(newRecord);
                    }else{
                      //編輯資料
                      final int id = int.parse(widget.record!['id']);
                      await DatabaseHelper.instance.updateRecord(id, newRecord);
                    }
                    // 再跳回上一頁，回傳 true 表示有更動
                    Navigator.pop(context, true);
                  } catch (e) {
                    print('新增失敗:$e');
                  }
                },
                child: Text(widget.record == null ? '儲存' : '更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
