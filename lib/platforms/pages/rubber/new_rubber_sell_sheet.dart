import 'package:flutter/material.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/farm/rubber_sell_record.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/core/types/weight_unit.dart';
import 'package:money_manager/platforms/components/dialog/error_alert_dialog.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_daily_work_list_page.dart';
import 'package:t_widgets/t_widgets.dart';

class NewRubberSellSheet extends StatefulWidget {
  const new({super.key, required this.site, required this.onSave});

  final MyWorkSite site;
  final ValueChanged<RubberSellRecord> onSave;

  @override
  State<NewRubberSellSheet> createState() => NewRubberSellSheetState();

  static Future<void> show(
    BuildContext context, {
    required MyWorkSite site,
    required ValueChanged<RubberSellRecord> onSave,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return NewRubberSellSheet(site: site, onSave: onSave);
      },
    );
  }
}

class NewRubberSellSheetState extends State<NewRubberSellSheet> {
  final _formKey = GlobalKey<FormState>();

  final _buyerController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  final _workerSellMoneyCon = TextEditingController();
  WeightUnit _weightUnit = .pound;
  List<RubberDailyWork> dailyWorks = [];

  DateTime _date = DateTime.now();

  double get weight {
    return double.tryParse(_weightController.text) ?? 0;
  }

  double get pricePerKg {
    return double.tryParse(_priceController.text) ?? 0;
  }

  double get total {
    return weight * pricePerKg;
  }

  @override
  void initState() {
    super.initState();

    _weightController.addListener(_refresh);
    _priceController.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      setState(() {
        _date = result;
      });
    }
  }

  String toMoneyLabel(double value) {
    final text = value.toStringAsFixed(0);
    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  void chooseWorkDays() async {
    final res = await context.pushMaterialPageRoute<List<RubberDailyWork>>(
      builder: (mainCtx) => RubberDailyWorkListPage(site: widget.site),
    );
    if (res == null) return;
    dailyWorks = res;
    if (!mounted) return;
    setState(() {});
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (dailyWorks.isEmpty) {
      showErrorDialog(context, 'အလုပ်ရက်များ ရွေးချယ်ပါ!');
      return;
    }

    final record = RubberSellRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      workSiteId: widget.site.id,
      rubberDailyWorkIds: dailyWorks.map((e) => e.id).toList(),
      weight: weight,
      pricePerUnit: pricePerKg,
      weightUnit: .pound,
      sellMoney: total,
      workerSellMoney: double.tryParse(_workerSellMoneyCon.text) ?? 0.0,
      buyer: _buyerController.text.trim(),
      note: _noteController.text.trim(),
      date: _date,
    );

    widget.onSave(record);

    Navigator.pop(context);
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
            children: [
              Text(
                'ရော်ဘာအရောင်းအသစ်',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('ရောင်းတဲ့နေ့'),
                subtitle: Text('${_date.day}/${_date.month}/${_date.year}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),

              const SizedBox(height: 8),

              // Buyer
              TextFormField(
                controller: _buyerController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'ဝယ်သူ',
                  hintText: 'ဥပမာ - ဦးကျော်',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ဝယ်သူအမည်ထည့်ပါ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'အလေးချိန်',
                  hintText: '0.0',
                  suffixText: 'kg',
                  prefixIcon: Icon(Icons.scale_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = double.tryParse(value ?? '');

                  if (number == null || number <= 0) {
                    return 'အလေးချိန်မှန်ကန်စွာထည့်ပါ';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),
              // အလေးချိန်
              DropdownButtonFormField<WeightUnit>(
                initialValue: _weightUnit,
                decoration: const InputDecoration(
                  labelText: 'အလေးချိန်ယူနစ်',
                  prefixIcon: Icon(Icons.scale_outlined),
                  border: OutlineInputBorder(),
                ),
                items: WeightUnit.values.map((unit) {
                  return DropdownMenuItem(value: unit, child: Text(unit.label));
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _weightUnit = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: '1 ${_weightUnit.label} ဈေး',
                  hintText: '0',
                  suffixText: 'ကျပ်',
                  prefixIcon: Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = double.tryParse(value ?? '');

                  if (number == null || number <= 0) {
                    return 'ဈေးနှုန်းမှန်ကန်စွာထည့်ပါ';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Total စျေးနှန်း
              _total(context),
              const SizedBox(height: 20),
              _workerSellMoney(),
              const SizedBox(height: 20),

              // Daily works
              _dailyWorkChooser(),

              const SizedBox(height: 8),

              // Note
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'မှတ်ချက်',
                  hintText: 'မှတ်ထားလိုတာရှိရင် ရေးပါ',
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Save
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'အရောင်းစာရင်းသိမ်းမည်',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dailyWorkChooser() {
    return Column(
      spacing: 10,
      crossAxisAlignment: .start,
      children: [
        if (dailyWorks.isNotEmpty)
          Text(
            'အလုပ်လုပ်ခဲ့တဲ့ ရက်များ: ${dailyWorks.length}',
            style: TextStyle(
              fontWeight: .w700,
              fontSize: 18,
              color: col.tertiary,
            ),
          ),
        ListTile(
          tileColor: dailyWorks.isEmpty ? col.onError : null,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.work_history_outlined),
          title: const Text('အလုပ်ရက်များ'),
          subtitle: const Text('ဒီအရောင်းမှာ ပါဝင်တဲ့ အလုပ်ရက်တွေရွေးရန်'),
          trailing: const Icon(Icons.chevron_right),
          onTap: chooseWorkDays,
        ),
      ],
    );
  }

  TextFormField _workerSellMoney() {
    return TextFormField(
      controller: _workerSellMoneyCon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'အလုပ်သမား ရငွေ',
        hintText: '0',
        suffixText: 'ကျပ်',
        prefixIcon: Icon(Icons.payments_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final number = double.tryParse(value ?? '');

        if (number == null || number <= 0) {
          return 'ငွေကို မှန်ကန်စွာထည့်ပါ';
        }

        return null;
      },
    );
  }

  Card _total(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.calculate_outlined, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'စုစုပေါင်းရောင်းရငွေ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${toMoneyLabel(total)} ကျပ်',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
