import 'package:flutter/cupertino.dart';
import 'package:no15/models/record_model.dart';

import '../database_helper.dart';

class RecordViewModel extends ChangeNotifier{
  Map<String, List<CropRecordModel>> _groupedRecords = {};
  Map<String, List<CropRecordModel>> get groupedRecords => _groupedRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 業務邏輯：抓取並整理資料
  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners(); // 通知 View 顯示載入中

    final records = await DatabaseHelper.instance.getRecords();
    Map<String, List<CropRecordModel>> newGroups = {};

    for (var map in records) {
      final record = CropRecordModel.fromMap(map);
      if (!newGroups.containsKey(record.date)) {
        newGroups[record.date] = [];
      }
      newGroups[record.date]!.add(record);
    }

    _groupedRecords = newGroups;
    _isLoading = false;
    notifyListeners(); // 通知 View 更新 UI
  }

  // 新增紀錄
  Future<void> addRecord(CropRecordModel record) async {
    await DatabaseHelper.instance.insertRecord(record.toMap());
    await loadRecords();
  }

  // 編輯紀錄
  Future<void> updateRecord(CropRecordModel record) async {
    if (record.id == null) return;
    // 呼叫 DatabaseHelper 的 updateRecord，並傳入轉好的 Map
    await DatabaseHelper.instance.updateRecord(record.id!, record.toMap());
    // 更新完資料庫後，重新讀取資料並通知畫面更新
    await loadRecords();
  }

  // 刪除邏輯
  Future<void> deleteRecord(int id) async {
    await DatabaseHelper.instance.deleteRecord(id);
    await loadRecords(); // 重新整理
  }

  // 取得「僅包含肥料」的分組資料
  Map<String, List<CropRecordModel>> get groupedMuckRecords {
    Map<String, List<CropRecordModel>> filteredGroups = {};

    _groupedRecords.forEach((date, records) {
      // 針對每一天的紀錄進行過濾
      final muckRecords = records.where((record) => record.fertilizer_used).toList();

      // 如果這天有過濾出肥料紀錄，才加入最終結果
      if (muckRecords.isNotEmpty) {
        filteredGroups[date] = muckRecords;
      }
    });

    return filteredGroups;
  }
}