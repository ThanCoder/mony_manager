import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/farm/rubber_sell_record.dart';

class RubberSellRecordDataChanged extends IControllerEvent {}

class RubberSellRecordController extends IController {
  final db = DB.store;
  List<RubberSellRecord> list = [];
  Map<String, RubberSellRecord> map = {};

  DuBox<RubberSellRecord> get box => db.getBox<RubberSellRecord>();

  @override
  Future<void> init() async {
    ControllerManager.read<MyWorkSiteController>().events
        .whereType<MyWorkSiteDataChanged>()
        .listen((event) {
          fetchList();
        });
    fetchList();
  }

  Future<void> fetchList() async {
    addEvent(RubberSellRecordDataChanged());
    list = await box.getAll();
    // list.sortDate();
    for (var d in list) {
      map[d.id] = d;
    }

    addEvent(RubberSellRecordDataChanged());
  }

  Future<void> add(RubberDailyWork work) async {
    // list.add(work);
    // await box.add(work);
    // list.sortDate();
    addEvent(RubberSellRecordDataChanged());
  }

  void delete(RubberDailyWork work) async {
    // final index = list.indexWhere((e) => e.generatedId == work.generatedId);
    // if (index != -1) {
    //   list.removeAt(index);
    // }
    await box.deleteById(work.generatedId);
    addEvent(RubberSellRecordDataChanged());
  }

  Future<void> update(int generatedId, RubberDailyWork work) async {
    // final index = list.indexWhere((e) => e.generatedId == generatedId);
    // if (index != -1) {
    //   list[index] = work;
    // }
    // await box.update(generatedId, value: work);
    addEvent(RubberSellRecordDataChanged());
  }
}
