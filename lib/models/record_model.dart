const Map<String, String> taskIcons = {
  '播種': 'assets/seed.png',
  '施肥': 'assets/muck.png',
  '採收': 'assets/harvest.png',
  '灌溉': 'assets/water.png',
  '除草': 'assets/grass.png',
  '防病蟲害': 'assets/worm.png',
  '整地': 'assets/land.png',
  '其他': 'assets/other.png',
};

class CropRecordModel {
  final int? id;
  final String date;
  final String crops;
  final String task;
  final String field;
  final String note;
  final bool fertilizer_used;
  final String? fertilizer_type;
  final double? fertilizer_amount;
  final String? fertilizer_unit;

  CropRecordModel({
    this.id,
    required this.date,
    required this.crops,
    required this.task,
    required this.field,
    required this.note,
    required this.fertilizer_used,
    this.fertilizer_type,
    this.fertilizer_amount,
    this.fertilizer_unit,
  });

  //告訴畫面要顯示什麼備註
  String get displayNote => note.isEmpty ? '-' : note;

  //告訴畫面要載入哪張圖片
  String get taskIcon => taskIcons[task] ?? 'assets/grass.png';

  // 將資料庫的 Map 轉換為物件
  factory CropRecordModel.fromMap(Map<String, dynamic> map) {
    return CropRecordModel(
      id: map['id'],
      date: map['date'] ?? '',
      crops: map['crops'] ?? '',
      task: map['task'] ?? '',
      field: map['field'] ?? '',
      note: map['note'] ?? '',
      fertilizer_used: map['fertilizer_used'] == 1,
      fertilizer_type: map['fertilizer_type']?.toString(),
      fertilizer_amount: map['fertilizer_amount'] != null
          ? double.tryParse(map['fertilizer_amount'].toString())
          : null,
      fertilizer_unit: map['fertilizer_unit'],
    );
  }

  Map<String,dynamic> toMap() => {
    if (id != null) 'id': id,
    'date':date,
    'crops':crops,
    'task':task,
    'field':field,
    'note':note,
    'fertilizer_used': fertilizer_used ? 1 : 0,
    'fertilizer_type': fertilizer_type,
    'fertilizer_amount': fertilizer_amount,
    'fertilizer_unit': fertilizer_unit,
  };
}
