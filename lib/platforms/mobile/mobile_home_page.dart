import 'package:flutter/material.dart';
import 'package:mony_manager/core/utils/app_util.dart';

class MobileHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppUtil.instance.appName)),
      body: Column(
        spacing: 10,
        children: [
          _listItem('စုဘူး', icon: Icon(Icons.savings_outlined, size: 80)),
          _listItem(
            'အစီးလျှီးရောဘာခြံ',
            icon: Icon(Icons.agriculture_outlined, size: 80),
          ),
          _listItem(
            'ဆောက်လုပ်ရေး',
            icon: Icon(Icons.construction_outlined, size: 80),
          ),
        ],
      ),
    );
  }

  Widget _listItem(
    String title, {
    required Widget icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        padding: .symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(14),
        ),
        child: Row(
          spacing: 8,
          children: [
            SizedBox(width: 80, height: 80, child: icon),
            Text(title),
          ],
        ),
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
