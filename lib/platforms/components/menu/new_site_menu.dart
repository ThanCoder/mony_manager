import 'package:flutter/material.dart';
import 'package:mony_manager/core/models/work_site.dart';
import 'package:mony_manager/core/work_site_data.dart';

class NewSiteMenu extends StatefulWidget {
  const new({super.key});

  @override
  State<NewSiteMenu> createState() => _NewSiteMenuState();
}

class _NewSiteMenuState extends State<NewSiteMenu> {
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workSiteList.length,
      itemBuilder: (context, index) => _listItem(workSiteList[index]),
    );
  }

  Widget _listItem(WorkSite site) {
    return GestureDetector(
      onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
