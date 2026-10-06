import 'package:flutter/material.dart';
import 'package:money_manager/core/models/work_site.dart';

class NewSavingFormPage extends StatefulWidget {
  const new({super.key, required this.site});
  final WorkSite site;

  @override
  State<NewSavingFormPage> createState() => _NewSavingFormPageState();
}

class _NewSavingFormPageState extends State<NewSavingFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Saving')),
      body: Column(children: []),
    );
  }
}
