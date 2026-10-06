import 'package:flutter/material.dart';
import 'package:mony_manager/core/utils/app_util.dart';

import 'platforms/platform_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  runApp(const PlatformApp());
}



class RubberDailyWork {
  final String siteId;
  final String workerId;
  final DateTime startWorkTime;

  final DateTime endWorkTime;

  /// Number of rubber slices.
  final int rubberSliceCount;

  const RubberDailyWork({
    required this.siteId,
    required this.workerId,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.rubberSliceCount,
  });
}
