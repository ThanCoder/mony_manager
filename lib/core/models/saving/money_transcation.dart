enum MoneyTransactionType { income, expense }

enum MoneyCategory {
  salary,
  farm,
  construction,
  saving,
  food,
  transport,
  shopping,
  other,
}

class MoneyTransaction {
  final String id;

  /// ငွေဝင် / ငွေထွက်
  final MoneyTransactionType type;

  final MoneyCategory category;

  /// ပမာဏ
  final double amount;

  /// ဘာအတွက်လဲ
  final String title;

  /// အသေးစိတ်
  final String? description;

  /// ဘယ်အချိန်ဖြစ်လဲ
  final DateTime date;

  const MoneyTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    this.description,
    required this.date,
    required this.category,
  });

  bool get isIncome => type == .income;
  bool get isExpense => type == .expense;
}
