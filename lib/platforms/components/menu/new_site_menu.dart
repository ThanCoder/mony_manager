import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/models/work_site.dart';
import 'package:money_manager/core/work_site_data.dart';
import 'package:money_manager/platforms/components/menu/new_work_site_sheet.dart';
import 'package:t_widgets/t_widgets.dart';

class NewSiteMenu extends StatefulWidget {
  const new({super.key});

  @override
  State<NewSiteMenu> createState() => _NewSiteMenuState();
}

class _NewSiteMenuState extends State<NewSiteMenu> {
  final con = ControllerManager.read<MyWorkSiteController>();
  void newWorkSite(WorkSite site) {
    context.pop();
    NewWorkSiteSheet.show(
      context,
      onSave: (site) {
        con.box.add(site);
      },
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: workSiteList.length,
        itemBuilder: (context, index) => _listItem(workSiteList[index]),
      ),
    );
  }

  Widget _listItem(WorkSite site) {
    return GestureDetector(
      onTap: () {
        newWorkSite(site);
      },
      child: Container(
        padding: .symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(14),
        ),
        child: Row(
          spacing: 8,
          children: [
            SizedBox(width: 80, height: 80, child: site.icon),
            Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text(
                  site.title,
                  style: TextStyle(fontWeight: .w600, color: col.onSurface),
                ),
                Text(
                  site.desc,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: .w400,
                    color: col.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.add_circle_outline),
          ],
        ),
      ),
    );
  }
}
