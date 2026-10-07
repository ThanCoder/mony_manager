import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/core/work_site_data.dart';
import 'package:money_manager/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:money_manager/platforms/pages/rubber/add_rubber_daily_work_sheet.dart';
import 'package:t_widgets/t_widgets.dart';

class RubberItemMenu extends StatefulWidget {
  const new({super.key, required this.work, required this.site});
  final RubberDailyWork work;
  final MyWorkSite site;

  @override
  State<RubberItemMenu> createState() => _RubberItemMenuState();

  static Future<void> show(
    BuildContext context,
    RubberDailyWork work, {
    required MyWorkSite site,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => RubberItemMenu(work: work, site: site),
    );
  }
}

class _RubberItemMenuState extends State<RubberItemMenu> {
  final con = ControllerManager.read<RubberSiteController>();

  void delConfirm() async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete?',
      closeText: 'No',
      confirmText: 'Delete Forever',
      confirmColor: col.onError,
      confirmForegroundColor: col.error,
    );
    if (!conf) return;
    con.delete(widget.work);
  }

  void edit() async {
    await AddRubberDailyWorkSheet.show(
      context,
      sites: [widget.site],
      workers: workers,
      work: widget.work,
      onSave: (work) {
        con.update(widget.work.generatedId, work);
      },
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            ListTile(
              contentPadding: .symmetric(vertical: 5, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              tileColor: col.secondaryContainer,
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Daily Work'),
              onTap: () {
                context.pop();
                edit();
              },
            ),
            ListTile(
              contentPadding: .symmetric(vertical: 5, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              tileColor: col.errorContainer,
              leading: Icon(Icons.delete_forever),
              title: Text('Delete Daily Work'),
              onTap: () {
                context.pop();
                delConfirm();
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
