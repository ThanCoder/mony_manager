import 'package:flutter/material.dart';

enum WorkSiteType {
  rubber,
  saving,
  none;

  String get typeName {
    return switch (this) {
      rubber => 'Rubber',
      saving => 'Saving',
      .none => 'None',
      // construction => 'Construction',
      // farm => 'Farm',
    };
  }

  IconData get typeIcon {
    return switch (this) {
      WorkSiteType.rubber => Icons.eco_outlined,
      // WorkSiteType.construction => Icons.construction_outlined,
      // WorkSiteType.farm => Icons.agriculture_outlined,
      WorkSiteType.saving => Icons.savings_outlined,
      .none => Icons.no_accounts,
    };
  }

  static WorkSiteType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .none);
  }
}

enum WorkRole {
  // employer, // အလုပ်ရှင်
  worker, // အလုပ်သမား
  // teamLeader, // အလုပ်သမားခေါင်း
  // contractor,
  none // ကန်ထရိုက်တာ
  ;

  String get roleName {
    return switch (this) {
      worker => 'Worker',
      .none => 'None',
      // employer => 'Employer',
      // teamLeader => 'Team Leader',
      // contractor => 'Contractor',
    };
  }

  static WorkRole fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .none);
  }
}
