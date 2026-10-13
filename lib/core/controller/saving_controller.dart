import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/db.dart';
import 'package:money_manager/core/models/saving/money_transcation.dart';

class SavingDataChanged extends IControllerEvent {}

class SavingController extends IController {
  final db = DB.store;
  List<MoneyTransaction> list = [];
  Map<String, MoneyTransaction> map = {};
  bool isLoading = false;

  DuBox<MoneyTransaction> get box => db.getBox<MoneyTransaction>();
  String siteId = '';

  @override
  Future<void> init() async {
    ControllerManager.read<MyWorkSiteController>().events
        .whereType<MyWorkSiteDataChanged>()
        .listen((event) {
          fetchList(siteId);
        });
    fetchList(siteId);
  }

  Future<void> fetchList(String siteId) async {
    isLoading = true;
    addEvent(SavingDataChanged());
    list = await box.find((val) => val.siteId == siteId);
    list.sortDate();
    for (var d in list) {
      map[d.id] = d;
    }
    isLoading = false;
    addEvent(SavingDataChanged());
  }

  Future<void> add(MoneyTransaction work) async {
    list.add(work);
    await box.add(work);
    list.sortDate();
    addEvent(SavingDataChanged());
  }

  void delete(MoneyTransaction work) async {
    final index = list.indexWhere((e) => e.generatedId == work.generatedId);
    if (index != -1) {
      list.removeAt(index);
    }
    await box.deleteById(work.generatedId);
    addEvent(SavingDataChanged());
  }

  Future<void> update(int generatedId, MoneyTransaction work) async {
    final index = list.indexWhere((e) => e.generatedId == generatedId);
    if (index != -1) {
      list[index] = work;
    }
    await box.updateByid(generatedId, value: work);
    addEvent(SavingDataChanged());
  }
}
