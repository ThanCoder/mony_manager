import 'package:flutter/material.dart';

enum WorkSiteType { construction, farm, saving }

enum WorkRole {
  employer, // အလုပ်ရှင်
  worker, // အလုပ်သမား
  teamLeader, // အလုပ်သမားခေါင်း
  contractor, // ကန်ထရိုက်တာ
}

class WorkSite {
  final String title;
  final WorkSiteType type;
  final WorkRole role;
  final String desc;
  final Widget icon;

  const WorkSite({
    required this.title,
    required this.type,
    required this.role,
    required this.desc,
    required this.icon,
  });
}
