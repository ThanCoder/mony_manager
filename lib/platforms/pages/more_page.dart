import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

import '../components/dialog/app_about_dialog.dart';
import 'dev_pages/dev_route_tile.dart';
import 'version_manager.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: TScrollableColumn(
        padding: .symmetric(vertical: 10, horizontal: 15),
        children: [
          TMaterialThemeProviderChooser(),
          VersionManager(
            githubUrl: 'https://github.com/ThanCoder/mony_manager',
          ),
          // CacheManagerListTile(
          //   cacheDirPath: AppUtil.instance.getPlatformCachePath(),
          // ),
          DevRouteTile(),
          AppAboutDialogListTile(appDesc: 'ငွေကြေးစီမံရေး Application.'),
        ],
      ),
    );
  }
}
