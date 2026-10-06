import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/models/work_site.dart';

class MyWorkSiteAdapter extends IDuBinaryMetaAdapter<MyWorkSite> {
  @override
  int get adapterId => 1;

  @override
  MyWorkSite fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(MyWorkSite value) {
    return value.toJson();
  }
}

class MyWorkSite extends IDuModel {
  final String id;
  final String title;
  final WorkSiteType type;
  final WorkRole role;
  final String desc;
  final DateTime createDate;

  MyWorkSite({
    required this.id,
    required this.title,
    required this.type,
    required this.role,
    required this.desc,
    required this.createDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'role': role.name,
      'desc': desc,
      'createDate': createDate.millisecondsSinceEpoch,
    };
  }

  factory MyWorkSite.fromJson(Map<String, dynamic> json) {
    return MyWorkSite(
      id: json['id'],
      title: json['title'],
      type: .fromValue(json['type']),
      role: .fromValue(json['role']),
      desc: json['desc'],
      createDate: DateTime.fromMillisecondsSinceEpoch(json['createDate']),
    );
  }
}
