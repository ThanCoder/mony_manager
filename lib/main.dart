import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/core/utils/app_util.dart';

import 'platforms/platform_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  DB.store.registerAdapter(MyWorkSiteAdapter());
  DB.store.registerAdapter(RubberDailyWorkAdapter());

  ControllerManager.register(MyWorkSiteController());
  ControllerManager.register(RubberSiteController());
  await ControllerManager.initAll();

  runApp(const PlatformApp());
}
