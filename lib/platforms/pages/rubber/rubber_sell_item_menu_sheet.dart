import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/new_rubber_sell_sheet.dart';
import 'package:t_widgets/t_widgets.dart';

class RubberSellItemMenuSheet extends StatefulWidget {
  const new({super.key, required this.record, required this.site});
  final RubberSellRecord record;
  final MyWorkSite site;

  @override
  State<RubberSellItemMenuSheet> createState() =>
      _RubberSellItemMenuSheetState();

  static Future<void> show(
    BuildContext context, {
    required RubberSellRecord record,
    required MyWorkSite site,
  }) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => RubberSellItemMenuSheet(record: record, site: site),
    );
  }
}

class _RubberSellItemMenuSheetState extends State<RubberSellItemMenuSheet> {
  final sellRecCon = ControllerManager.read<RubberSellRecordController>();
  final rubberCon = ControllerManager.read<RubberSiteController>();

  void _showNewRubberSellSheet(RubberSellRecord record) async {
    await NewRubberSellSheet.show(
      context,
      site: widget.site,
      editRecord: record,
      onSave: (resp) async {
        for (var wd in resp.dailyWorks) {
          await rubberCon.update(wd.generatedId, wd.copyWith(paid: true));
        }
        await sellRecCon.update(record.generatedId, resp.record);
      },
    );
  }

  void deleteMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [
            ListTile(
              tileColor: col.errorContainer,
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('ရောင်းပြီးအလုပ်ရက် ပြန်ပြင်ချင်း'),
              subtitle: Text(
                'ရောင်းလို့သတ်မှာထားတဲ့ နေ့စဥ် အလုပ်လုပ်ခဲ့တဲ့နေ့ကို ပြန်လည် ပြောင်းလဲပြီး ဖျက်လိုက်မလား?',
              ),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              tileColor: col.errorContainer,
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('တစ်ခါတည်း ဖျက်ပစ်ခြင်း'),
              subtitle: Text('ဘာမှမလုပ်ဘဲ အခု စာရင်းကိုပဲ ဖျက်ပစ်ခြင်း'),
              onTap: () {
                context.pop();
                sellRecCon.delete(widget.record);
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        children: [
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text('Edit'),
            onTap: () {
              context.pop();
              _showNewRubberSellSheet(widget.record);
            },
          ),
          ListTile(
            tileColor: col.errorContainer,
            leading: Icon(Icons.delete_forever_outlined),
            title: Text('Delete'),
            onTap: () {
              context.pop();
              deleteMenu();
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
