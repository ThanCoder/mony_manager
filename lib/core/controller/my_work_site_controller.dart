import 'dart:io';

import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class MyWorkSiteDataChanged extends IControllerEvent {}

class MyWorkSiteController extends IController {
  final db = DB.store;
  List<MyWorkSite> list = [];

  DuBox<MyWorkSite> get box => db.getBox<MyWorkSite>();

  @override
  Future<void> init() async {
    box.events.all.listen((event) {
      fetchList();
    });
    if (Platform.isAndroid) {
      final pkg = ThanPkgAndroid.getInstance.storagePermissionHandler;
      if (!await pkg.isStoragePermissionGranted()) {
        await pkg.requestStoragePermission();
        return;
      }
    }
    await DB.store.reloadIfNotOpened();
    await fetchList();
  }

  Future<void> fetchList() async {
    addEvent(MyWorkSiteDataChanged());
    list = await box.getAll();
    list.sort((a, b) {
      if (a.type == .saving && b.type != .saving) return -1;
      if (b.type == .saving && a.type != .saving) return 1;
      return 0;
    });
    addEvent(MyWorkSiteDataChanged());
  }
}
