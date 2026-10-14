import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';

class RubberSellRecordDataChanged extends IControllerEvent {}

class RubberSellRecordController extends IController {
  final db = DB.store;
  List<RubberSellRecord> list = [];
  Map<String, RubberSellRecord> map = {};

  DuBox<RubberSellRecord> get box => db.getBox<RubberSellRecord>();
  late final _workSiteCon = ControllerManager.read<MyWorkSiteController>();

  String siteId = '';

  @override
  Future<void> init() async {
    ControllerManager.read<MyWorkSiteController>().events
        .whereType<MyWorkSiteDataChanged>()
        .listen((event) {
          fetchList(siteId);
        });
    _workSiteCon.events.whereType<MyWorkSiteDeleted>().listen((event) async {
      await box.delete((value) => value.workSiteId == event.siteId);
      fetchList(event.siteId);
      print('[RubberSellRecordController]: deleted');
    });
    fetchList(siteId);
  }

  Future<void> fetchList(String siteId) async {
    addEvent(RubberSellRecordDataChanged());
    list = await box.find((val) => val.workSiteId == siteId);
    list.sortDate();
    for (var d in list) {
      map[d.id] = d;
    }

    addEvent(RubberSellRecordDataChanged());
  }

  Future<void> add(RubberSellRecord work) async {
    list.add(work);
    await box.add(work);
    list.sortDate();
    addEvent(RubberSellRecordDataChanged());
  }

  void delete(RubberSellRecord work) async {
    final index = list.indexWhere((e) => e.generatedId == work.generatedId);
    if (index != -1) {
      list.removeAt(index);
    }
    await box.deleteById(work.generatedId);
    addEvent(RubberSellRecordDataChanged());
  }

  Future<void> update(int generatedId, RubberSellRecord work) async {
    final index = list.indexWhere((e) => e.generatedId == generatedId);
    if (index != -1) {
      list[index] = work;
    }
    await box.updateByid(generatedId, value: work);
    addEvent(RubberSellRecordDataChanged());
  }
}
