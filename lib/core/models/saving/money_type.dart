part of 'money_transcation.dart';

enum MoneyTransactionType {
  income,
  expense;

  IconData get icon => switch (this) {
    .income => Icons.arrow_downward,
    .expense => Icons.arrow_upward,
  };

  static MoneyTransactionType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .income);
  }
}

enum MoneyCategory {
  salary,
  saving,
  food,
  transport,
  shopping,
  phoneBill,
  onlinePayment,
  farm,
  construction,
  other;

  IconData get icon => switch (this) {
    .salary => Icons.payments_outlined,
    .saving => Icons.savings_outlined,
    .food => Icons.restaurant_outlined,
    .transport => Icons.directions_car_outlined,
    .shopping => Icons.shopping_bag_outlined,
    .phoneBill => Icons.phone_android_outlined,
    .onlinePayment => Icons.payment_outlined,
    .farm => Icons.agriculture_outlined,
    .construction => Icons.construction_outlined,
    .other => Icons.category_outlined,
  };

  static MoneyCategory fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .other);
  }
}
