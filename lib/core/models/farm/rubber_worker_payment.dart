class RubberWorkerPayment {
  final String id;
  final String workSiteId;
  final String rubberSellRecordId;
  final String workerId;

  /// အလုပ်သမားကို တကယ်ပေးလိုက်တဲ့ငွေ
  final double money;

  final DateTime date;
  final String note;

  const RubberWorkerPayment({
    required this.id,
    required this.workSiteId,
    required this.rubberSellRecordId,
    required this.workerId,
    required this.money,
    required this.date,
    required this.note,
  });
}
