import 'package:flutter/material.dart';
import 'package:money_manager/core/types/work_types.dart';

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
