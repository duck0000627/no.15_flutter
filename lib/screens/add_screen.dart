import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

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

  final List<String> _cropsOptions = [
    '黃豆',
    '黑豆',
  ];

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

  final List<String> _fieldOptions = [
    'A1',
    'A2',
    'A3',
    'A4',
    'A5',
    'A6',
  ];


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
      appBar: AppBar(title: const Text('新增紀錄')),
      body: Padding(padding: const EdgeInsets.all(16.0),
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
                  items: _cropsOptions.map((task){
                    return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                    );
                  }).toList(),
                  onChanged: (value){
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
                  items: _taskOptions.map((task){
                    return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                    );
                  }).toList(),
                  onChanged: (value){
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
                  items: _fieldOptions.map((task){
                    return DropdownMenuItem<String>(
                        value: task,
                        child: Text(task),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      _field = value ?? '';
                    });
                  },
                onSaved: (value) => _field = value ?? '',
              ),
              //備註
              TextFormField(
                decoration: const InputDecoration(labelText: '備註'),
                onSaved: (value) => _note = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  _formKey.currentState?.save();
                  Navigator.pop(context,{
                    'date': formattedDate,
                    'crops' : _crops,
                    'task' : _task,
                    'field' : _field,
                    'note' : _note,
                  });
                },
                child: const Text('save'),),
            ],
          )),
      ),
    );
  }
}

