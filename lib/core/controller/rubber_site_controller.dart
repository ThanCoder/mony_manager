import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/farm/rubber.dart';

class RubberSiteDataChanged extends IControllerEvent {}

class RubberSiteController extends IController {
  final db = DB.store;
  List<RubberDailyWork> list = [];

  DuBox<RubberDailyWork> get box => db.getBox<RubberDailyWork>();

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
    addEvent(RubberSiteDataChanged());
    list = await box.getAll();
    list.sortDate();

    addEvent(RubberSiteDataChanged());
  }

  Future<void> add(RubberDailyWork work) async {
    list.add(work);
    list.sortDate();
    await box.add(work);
    addEvent(RubberSiteDataChanged());
  }

  void delete(RubberDailyWork work) async {
    final index = list.indexWhere((e) => e.generatedId == work.generatedId);
    if (index != -1) {
      list.removeAt(index);
    }
    await box.deleteById(work.generatedId);
    addEvent(RubberSiteDataChanged());
  }

  void update(int generatedId,RubberDailyWork work) async {
    final index = list.indexWhere((e) => e.generatedId == generatedId);
    if (index != -1) {
      list[index] = work;
    }
    await box.update(generatedId, value: work);
    addEvent(RubberSiteDataChanged());
  }
}
