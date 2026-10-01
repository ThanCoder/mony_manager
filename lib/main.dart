import 'package:flutter/material.dart';
import 'package:mony_manager/core/utils/app_util.dart';
import 'platforms/platform_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  runApp(const PlatformApp());
}
