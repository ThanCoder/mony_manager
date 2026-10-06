import 'package:flutter/material.dart';
import 'package:mony_manager/core/utils/app_util.dart';
import 'package:mony_manager/platforms/components/menu/new_site_menu.dart';

class MobileHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  void createSite() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => NewSiteMenu(),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppUtil.instance.appName)),
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: createSite,
        child: Icon(Icons.add_outlined),
      ),
    );
  }
}
/*
Farm
├── FarmEmployer
├── FarmWorker
├── FarmWork
└── FarmSettlement

Construction
├── ConstructionEmployer
├── ConstructionWorker
├── ConstructionProject
├── ConstructionWorkDay
└── ConstructionSettlement


Construction
│
├── ConstructionClient
│      └── အိမ်ရှင်
│
├── ConstructionContractor[ConstructionClient][ConstructionTeamLeader]
│      └── အလုပ်သမားခေါင်းဆောင်
│
├── ConstructionWorker
│      ├── Worker A
│      ├── Worker B
│      └── Worker C
│
└── ConstructionProject


 */
