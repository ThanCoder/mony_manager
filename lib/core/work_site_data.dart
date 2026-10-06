import 'package:flutter/material.dart';
import 'package:mony_manager/core/models/work_site.dart';

const workSiteList = <WorkSite>[
  .new(
    title: 'ငွေစုဗူး',
    type: .saving,
    role: .worker,
    desc: 'အစီးလျှီးအလုပ်များ',
    icon: Icon(Icons.savings_outlined),
  ),
  .new(
    title: 'ရောဘာခြံ',
    type: .farm,
    role: .worker,
    desc: 'အစီးလျှီးအလုပ်များ',
    icon: Icon(Icons.family_restroom),
  ),
];
