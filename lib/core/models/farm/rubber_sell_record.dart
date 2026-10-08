import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/types/weight_unit.dart';

class RubberSellRecordAdapter extends IDuBinaryMetaAdapter<RubberSellRecord> {
  @override
  int get adapterId => 3;

  @override
  RubberSellRecord fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(RubberSellRecord value) {
    return value.toJson();
  }
}

class RubberSellRecord extends IDuModel {
  final String id;
  final String workSiteId;
  final List<String> rubberDailyWorkIds;

  final double weight;
  final WeightUnit weightUnit;

  final double pricePerUnit;
  final double sellMoney;
  final double workerSellMoney;

  final String buyer;
  final String note;
  final DateTime date;

  RubberSellRecord({
    required this.id,
    required this.workSiteId,
    required this.rubberDailyWorkIds,
    required this.weight,
    required this.weightUnit,
    required this.pricePerUnit,
    required this.sellMoney,
    required this.buyer,
    required this.note,
    required this.date,
    required this.workerSellMoney,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workSiteId': workSiteId,
      'rubberDailyWorkIds': rubberDailyWorkIds,
      'weight': weight,
      'weightUnit': weightUnit.name,
      'pricePerUnit': pricePerUnit,
      'sellMoney': sellMoney,
      'workerSellMoney': workerSellMoney,
      'buyer': buyer,
      'note': note,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory RubberSellRecord.fromJson(Map<String, dynamic> json) {
    return RubberSellRecord(
      id: json['id'],
      workSiteId: json['workSiteId'],
      rubberDailyWorkIds: List<String>.from(json['rubberDailyWorkIds']),
      weight: json['weight'],
      weightUnit: WeightUnit.fromValue(json['weightUnit']),
      pricePerUnit: json['pricePerUnit'],
      sellMoney: json['sellMoney'],
      workerSellMoney: json['workerSellMoney'],
      buyer: json['buyer'],
      note: json['note'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  RubberSellRecord copyWith({
    String? id,
    String? workSiteId,
    List<String>? rubberDailyWorkIds,
    double? weight,
    WeightUnit? weightUnit,
    double? pricePerUnit,
    double? sellMoney,
    double? workerSellMoney,
    String? buyer,
    String? note,
    DateTime? date,
  }) {
    return RubberSellRecord(
      id: id ?? this.id,
      workSiteId: workSiteId ?? this.workSiteId,
      rubberDailyWorkIds: rubberDailyWorkIds ?? this.rubberDailyWorkIds,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      sellMoney: sellMoney ?? this.sellMoney,
      workerSellMoney: workerSellMoney ?? this.workerSellMoney,
      buyer: buyer ?? this.buyer,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return '''RubberSellRecord(id: $id, workSiteId: $workSiteId, rubberDailyWorkIds: $rubberDailyWorkIds, weight: $weight, weightUnit: $weightUnit, pricePerUnit: $pricePerUnit, sellMoney: $sellMoney, workerSellMoney: $workerSellMoney, buyer: $buyer, note: $note, date: $date)''';
  }
}
