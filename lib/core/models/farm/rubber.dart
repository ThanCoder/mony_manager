import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:money_manager/core/models/my_work_site.dart';

class RubberDailyWork {
  const RubberDailyWork({
    required this.siteId,
    required this.workerId,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.rubberSliceCount,
  });

  final MyWorkSite siteId;
  final String workerId;
  final DateTime startWorkTime;

  final DateTime endWorkTime;

  /// Number of rubber slices.
  final int rubberSliceCount;

  String get date => endWorkTime.formatTimeAgo();
}
