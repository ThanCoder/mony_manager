enum WeightUnit {
  pound,
  kilogram;

  String get label => switch (this) {
    .pound => 'ပေါင်',
    .kilogram => 'kg',
  };

  String get symbol => switch (this) {
    .pound => 'lb',
    .kilogram => 'kg',
  };
  static WeightUnit fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => pound);
  }
}
