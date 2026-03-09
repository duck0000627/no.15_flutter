import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no15/models/record_model.dart';
import '../view_models/GetxController.dart';

class AddRecordScreen extends StatefulWidget {
  final CropRecordModel? record;

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

  // 新增肥料相關狀態
  bool _fertilizer_used = false;
  String _fertilizer_type = '';
  String _fertilizer_amount = '';
  String _fertilizer_unit = '';

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
  final List<String> _fertilizer_units = ['公斤', '克', '包'];

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      final record = widget.record!;
      _crops = record.crops;
      _task = record.task;
      _field = record.field;
      _note = record.note;
      _fertilizer_used = record.fertilizer_used;
      _fertilizer_type = record.fertilizer_type ?? '';
      _fertilizer_amount = record.fertilizer_amount?.toString() ?? '';
      _fertilizer_unit = record.fertilizer_unit ?? '';

      // 將民國格式轉回西元 DateTime
      final parts = record.date.split('-');
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
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text(widget.record == null ? '新增紀錄' : '編輯紀錄'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              const Divider(),

              // 是否使用肥料
              SwitchListTile(
                title: const Text("是否使用肥料"),
                value: _fertilizer_used,
                onChanged: (val) {
                  setState(() {
                    _fertilizer_used = val;
                  });
                },
              ),

              if (_fertilizer_used) ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: '肥料種類'),
                  initialValue: _fertilizer_type,
                  onSaved: (v) => _fertilizer_type = v ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '肥料數量'),
                  keyboardType: TextInputType.number,
                  initialValue: _fertilizer_amount,
                  onSaved: (v) => _fertilizer_amount = v ?? '',
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: '單位'),
                  value: _fertilizer_unit.isNotEmpty ? _fertilizer_unit : null,
                  items:
                      _fertilizer_units
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _fertilizer_unit = v ?? ''),
                  onSaved: (v) => _fertilizer_unit = v ?? '',
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_crops != '' && _task != '' && _field != '') {
                    _formKey.currentState?.save();

                    final newRecord = CropRecordModel(
                      id: widget.record?.id,
                      date: formattedDate,
                      crops: _crops,
                      task: _task,
                      field: _field,
                      note: _note,
                      fertilizer_used: _fertilizer_used,
                      fertilizer_type: _fertilizer_used ? _fertilizer_type : null,
                      fertilizer_amount:
                          _fertilizer_used
                              ? double.tryParse(_fertilizer_amount)
                              : null,
                      fertilizer_unit: _fertilizer_used ? _fertilizer_unit : null,
                    );

                    try {
                      // 🔹 透過 GetX Controller 儲存資料
                      final controller = Get.find<RecordController>();
                      if (widget.record == null) {
                        // 新增
                        await controller.addRecord(newRecord);
                      } else {
                        // 編輯
                        await controller.updateRecord(newRecord);
                      }
                      // 🔹 儲存完畢後直接退回上一頁，畫面會由 GetX 自動重整！
                      Get.back();
                    } catch (e) {
                      '存檔失敗:$e';
                    }
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('請選擇所有選項')));
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
