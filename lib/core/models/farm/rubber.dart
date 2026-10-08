import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/datetime_x.dart';
import 'package:money_manager/core/models/my_work_site.dart';

class RubberDailyWorkAdapter extends IDuBinaryMetaAdapter<RubberDailyWork> {
  @override
  int get adapterId => 2;

  @override
  RubberDailyWork fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(RubberDailyWork value) {
    return value.toJson();
  }
}

class RubberDailyWork extends IDuModel {
  RubberDailyWork({
    required this.siteId,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.rubberSliceCount,
    required this.paid,
    required this.id,
  });
  final String id;
  final MyWorkSite siteId;
  final DateTime startWorkTime;

  final DateTime endWorkTime;

  /// Number of rubber slices.
  final int rubberSliceCount;
  final bool paid;

  String get date {
    if (endWorkTime.isToday) return 'Today';
    final d = endWorkTime;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId.toJson(),
      'startWorkTime': startWorkTime.millisecondsSinceEpoch,
      'endWorkTime': endWorkTime.millisecondsSinceEpoch,
      'rubberSliceCount': rubberSliceCount,
      'paid': paid,
    };
  }

  factory RubberDailyWork.fromJson(Map<String, dynamic> json) {
    return RubberDailyWork(
      id: json['id'],
      siteId: MyWorkSite.fromJson(json['siteId']),
      startWorkTime: DateTime.fromMillisecondsSinceEpoch(json['startWorkTime']),
      endWorkTime: DateTime.fromMillisecondsSinceEpoch(json['endWorkTime']),
      rubberSliceCount: json['rubberSliceCount'],
      paid: json['paid'],
    );
  }

  @override
  String toString() {
    return '''RubberDailyWork(id: $id, siteId: $siteId, startWorkTime: $startWorkTime, endWorkTime: $endWorkTime, rubberSliceCount: $rubberSliceCount, paid: $paid)''';
  }

  RubberDailyWork copyWith({
    String? id,
    MyWorkSite? siteId,
    DateTime? startWorkTime,
    DateTime? endWorkTime,
    int? rubberSliceCount,
    bool? paid,
  }) {
    return RubberDailyWork(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      startWorkTime: startWorkTime ?? this.startWorkTime,
      endWorkTime: endWorkTime ?? this.endWorkTime,
      rubberSliceCount: rubberSliceCount ?? this.rubberSliceCount,
      paid: paid ?? this.paid,
    );
  }
}

extension RubberDailyWorkX on List<RubberDailyWork> {
  void sortDate({bool newest = true}) {
    sort((a, b) {
      if (newest) {
        return b.endWorkTime.compareTo(a.endWorkTime);
      } else {
        return a.endWorkTime.compareTo(b.endWorkTime);
      }
    });
  }
}
