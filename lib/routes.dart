import 'package:flutter/material.dart';
import 'package:money_manager/core/models/work_site.dart';
import 'package:money_manager/platforms/pages/saving/new_saving_form_page.dart';
import 'package:t_widgets/t_widgets.dart';

Future<void> goNewSavingForm(
  BuildContext context, {
  required WorkSite site,
}) async {
  context.pushMaterialPageRoute(
    builder: (mainCtx) => NewSavingFormPage(site: site),
  );
}
