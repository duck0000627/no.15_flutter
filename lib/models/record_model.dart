class CropRecordModel {
  final int? id;
  final String date;
  final String crops;
  final String task;
  final String field;
  final String note;
  final bool fertilizerUsed;
  final String? fertilizerType;
  final double? fertilizerAmount;
  final String? fertilizerUnit;

  CropRecordModel({
    this.id,
    required this.date,
    required this.crops,
    required this.task,
    required this.field,
    required this.note,
    required this.fertilizerUsed,
    this.fertilizerType,
    this.fertilizerAmount,
    this.fertilizerUnit,
  });

  // 將資料庫的 Map 轉換為物件
  factory CropRecordModel.fromMap(Map<String, dynamic> map) {
    return CropRecordModel(
      id: map['id'],
      date: map['date'] ?? '',
      crops: map['crops'] ?? '',
      task: map['task'] ?? '',
      field: map['field'] ?? '',
      note: map['note'] ?? '',
      fertilizerUsed: map['fertilizerUsed'] == 1,
      fertilizerType: map['fertilizerType']?.toString(),
      fertilizerAmount: map['fertilizerAmount']?.toDouble(),
      fertilizerUnit: map['fertilizerUnit'],
    );
  }

  Map<String,dynamic> toMap() => {
    'id':id,
    'date':date,
    'crops':crops,
    'task':task,
    'field':field,
    'note':note,
    'fertilizerUsed':fertilizerUsed ? 1 : 0,
    'fertilizerType':fertilizerType,
    'fertilizerAmount':fertilizerAmount,
    'fertilizerUnit':fertilizerUnit,
  };
}
