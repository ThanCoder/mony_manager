import 'package:dual_store/dual_store.dart';
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
    required this.workerId,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.rubberSliceCount,
    required this.paid,
    required this.otherWorkers,
  });

  final MyWorkSite siteId;
  final String workerId;
  final DateTime startWorkTime;

  final DateTime endWorkTime;

  /// Number of rubber slices.
  final int rubberSliceCount;
  final bool paid;
  final List<String> otherWorkers;

  String get date {
    final d = endWorkTime;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'siteId': siteId.toJson(),
      'workerId': workerId,
      'startWorkTime': startWorkTime.millisecondsSinceEpoch,
      'endWorkTime': endWorkTime.millisecondsSinceEpoch,
      'rubberSliceCount': rubberSliceCount,
      'paid': paid,
      'otherWorkers': otherWorkers,
    };
  }

  factory RubberDailyWork.fromJson(Map<String, dynamic> json) {
    return RubberDailyWork(
      siteId: MyWorkSite.fromJson(json['siteId']),
      workerId: json['workerId'],
      startWorkTime: DateTime.fromMillisecondsSinceEpoch(json['startWorkTime']),
      endWorkTime: DateTime.fromMillisecondsSinceEpoch(json['endWorkTime']),
      rubberSliceCount: json['rubberSliceCount'],
      paid: json['paid'],
      otherWorkers: List<String>.from(json['otherWorkers']),
    );
  }

  @override
  String toString() {
    return '''RubberDailyWork(siteId: $siteId, workerId: $workerId, startWorkTime: $startWorkTime, endWorkTime: $endWorkTime, rubberSliceCount: $rubberSliceCount, paid: $paid, otherWorkers: $otherWorkers)''';
  }

  RubberDailyWork copyWith({
    MyWorkSite? siteId,
    String? workerId,
    DateTime? startWorkTime,
    DateTime? endWorkTime,
    int? rubberSliceCount,
    bool? paid,
    List<String>? otherWorkers,
  }) {
    return RubberDailyWork(
      siteId: siteId ?? this.siteId,
      workerId: workerId ?? this.workerId,
      startWorkTime: startWorkTime ?? this.startWorkTime,
      endWorkTime: endWorkTime ?? this.endWorkTime,
      rubberSliceCount: rubberSliceCount ?? this.rubberSliceCount,
      paid: paid ?? this.paid,
      otherWorkers: otherWorkers ?? this.otherWorkers,
    );
  }
}

extension RubberDailyWorkX on List<RubberDailyWork> {
  void sortDate({bool newest = true}) {
    sort((a, b) {
      if (newest) {
        return a.endWorkTime.compareTo(a.endWorkTime);
      } else {
        return a.endWorkTime.compareTo(b.endWorkTime);
      }
    });
  }
}
