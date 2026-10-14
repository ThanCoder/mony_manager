import 'dart:io';

import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class MyWorkSiteDataChanged extends IControllerEvent {}

class MyWorkSiteDeleted extends IControllerEvent {
  final String siteId;
  const MyWorkSiteDeleted(this.siteId);
}

class MyWorkSiteController extends IController {
  final db = DB.store;
  List<MyWorkSite> list = [];

  DuBox<MyWorkSite> get _box => db.getBox<MyWorkSite>();

  @override
  Future<void> init() async {
    // box.events.all.listen((event) {
    //   fetchList();
    // });
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
    list = await _box.getAll();
    list.sort((a, b) {
      if (a.type == .saving && b.type != .saving) return -1;
      if (b.type == .saving && a.type != .saving) return 1;
      return 0;
    });
    addEvent(MyWorkSiteDataChanged());
  }

  Future<void> add(MyWorkSite site) async {
    list.insert(0, site);
    list.sort((a, b) {
      if (a.type == .saving && b.type != .saving) return -1;
      if (b.type == .saving && a.type != .saving) return 1;
      return 0;
    });
    await _box.add(site);
    addEvent(MyWorkSiteDataChanged());
  }

  Future<void> update(int generatedId, MyWorkSite site) async {
    final index = list.indexWhere((e) => e.id == site.id);
    if (index == -1) return;
    list[index] = site;
    await _box.updateByid(generatedId, value: site);
    addEvent(MyWorkSiteDataChanged());
  }

  Future<void> delete(MyWorkSite site) async {
    final index = list.indexWhere((e) => e.id == site.id);
    if (index == -1) return;
    list.removeAt(index);
    await _box.deleteById(site.generatedId);

    addEvent(MyWorkSiteDataChanged());
    addEvent(MyWorkSiteDeleted(site.id));
  }
}
