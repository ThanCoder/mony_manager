import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';

part 'money_type.dart';

class MoneyTransactionAdapter extends IDuBinaryMetaAdapter<MoneyTransaction> {
  @override
  int get adapterId => 4;

  @override
  MoneyTransaction fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(MoneyTransaction value) {
    return value.toJson();
  }
}

class MoneyTransaction extends IDuModel {
  final String siteId;
  final String id;

  /// ငွေဝင် / ငွေထွက်
  final MoneyTransactionType type;

  final MoneyCategory category;

  /// ပမာဏ
  final double amount;

  /// ဘာအတွက်လဲ
  final String title;

  /// အသေးစိတ်
  final String description;

  /// ဘယ်အချိန်ဖြစ်လဲ
  final DateTime date;

  MoneyTransaction({
    required this.siteId,
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });

  bool get isIncome => type == .income;
  bool get isExpense => type == .expense;

  Map<String, dynamic> toJson() {
    return {
      'siteId': siteId,
      'id': id,
      'type': type.name,
      'category': category.name,
      'amount': amount,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory MoneyTransaction.fromJson(Map<String, dynamic> json) {
    return MoneyTransaction(
      siteId: json['siteId'],
      id: json['id'],
      type: MoneyTransactionType.fromValue(json['type']),
      category: MoneyCategory.fromValue(json['category']),
      amount: json['amount'],
      title: json['title'],
      description: json['description'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  MoneyTransaction copyWith({
    String? siteId,
    String? id,
    MoneyTransactionType? type,
    MoneyCategory? category,
    double? amount,
    String? title,
    String? description,
    DateTime? date,
  }) {
    return MoneyTransaction(
      siteId: siteId ?? this.siteId,
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}

extension MoneyTransactionX on List<MoneyTransaction> {
  void sortDate({bool newest = true}) {
    sort((a, b) {
      if (newest) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });
  }
}
