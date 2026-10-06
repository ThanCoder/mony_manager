import 'package:flutter/material.dart';

enum WorkSiteType {
  construction,
  rubber,
  farm,
  saving,
  none;

  String get typeName {
    return switch (this) {
      construction => 'Construction',
      rubber => 'Rubber',
      farm => 'Farm',
      saving => 'Saving',
      .none => 'None',
    };
  }

  IconData get typeIcon {
    return switch (this) {
      WorkSiteType.construction => Icons.construction_outlined,
      WorkSiteType.rubber => Icons.eco_outlined,
      WorkSiteType.farm => Icons.agriculture_outlined,
      WorkSiteType.saving => Icons.savings_outlined,
      .none => Icons.no_accounts,
    };
  }

  static WorkSiteType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .none);
  }
}

enum WorkRole {
  employer, // အလုပ်ရှင်
  worker, // အလုပ်သမား
  teamLeader, // အလုပ်သမားခေါင်း
  contractor,
  none // ကန်ထရိုက်တာ
  ;

  String get roleName {
    return switch (this) {
      employer => 'Employer',
      worker => 'Worker',
      teamLeader => 'Team Leader',
      contractor => 'Contractor',
      .none => 'None',
    };
  }

  static WorkRole fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .none);
  }
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
