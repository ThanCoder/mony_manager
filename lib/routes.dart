import 'package:flutter/material.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/rubber_home_page.dart';
import 'package:money_manager/platforms/pages/saving/saving_home_page.dart';
import 'package:t_widgets/t_widgets.dart';

Future<void> goAutoMyWorkSite(
  BuildContext context, {
  required MyWorkSite site,
}) async {
  if (site.type == .saving) {
    context.pushMaterialPageRoute(
      builder: (mainCtx) => SavingHomePage(site: site),
    );
  }
  if (site.type == .rubber) {
    context.pushMaterialPageRoute(
      builder: (mainCtx) => RubberHomePage(site: site),
    );
  }
}
