import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/core/models/saving/money_transcation.dart';

class SavingTranscationSheet extends StatefulWidget {
  const new({super.key, required this.type, this.editTrans, this.onSaved});

  final MoneyTransactionType type;
  final MoneyTransaction? editTrans;
  final void Function(MoneyTransaction trans)? onSaved;

  @override
  State<SavingTranscationSheet> createState() => _SavingTranscationSheetState();

  static Future<void> show(
    BuildContext context, {
    required MoneyTransactionType type,
    MoneyTransaction? editTrans,
    void Function(MoneyTransaction trans)? onSaved,
  }) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SavingTranscationSheet(
        type: type,
        editTrans: editTrans,
        onSaved: onSaved,
      ),
    );
  }
}

class _SavingTranscationSheetState extends State<SavingTranscationSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late MoneyCategory _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();

    final edit = widget.editTrans;

    _amountController = TextEditingController(
      text: edit == null ? '' : edit.amount.toStringAsFixed(0),
    );

    _titleController = TextEditingController(text: edit?.title ?? '');

    _descriptionController = TextEditingController(
      text: edit?.description ?? '',
    );

    _category = edit?.category ?? _defaultCategory;
    _date = edit?.date ?? DateTime.now();
  }

  MoneyCategory get _defaultCategory {
    return widget.type == .income ? MoneyCategory.salary : MoneyCategory.other;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result == null) return;

    setState(() {
      _date = DateTime(
        result.year,
        result.month,
        result.day,
        _date.hour,
        _date.minute,
      );
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.tryParse(_amountController.text.replaceAll(',', ''));

    final title = _titleController.text.trim();

    final old = widget.editTrans;

    final trans = MoneyTransaction(
      siteId: old?.siteId ?? '',
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: widget.type,
      category: _category,
      amount: amount ?? 0,
      title: title,
      description: _descriptionController.text.trim().isEmpty
          ? ''
          : _descriptionController.text.trim(),
      date: _date,
    );

    widget.onSaved?.call(trans);

    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = widget.type == .income;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          12,
          0,
          12,
          12 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.editTrans == null
                      ? isIncome
                            ? 'ငွေဝင်အသစ်'
                            : 'ငွေထွက်အသစ်'
                      : isIncome
                      ? 'ငွေဝင် ပြင်ဆင်ရန်'
                      : 'ငွေထွက် ပြင်ဆင်ရန်',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            _formWidget,
          ],
        ),
      ),
    );
  }

  Widget get _formWidget {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 12,
        children: [
          // Amount
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'ပမာဏ',
              hintText: '0',
              prefixIcon: const Icon(Icons.payments_outlined),
              suffixText: 'ကျပ်',
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              final amount = double.tryParse(value ?? '');
              if (value != null && amount != null) {
                if (amount <= 0) {
                  return 'ပမာဏ မှန်ကန်စွာ ထည့်ပါ';
                }
                return null;
              }
              return 'ပမာဏ မှန်ကန်စွာ ထည့်ပါ';
            },
          ),

          // Category
          DropdownButtonFormField<MoneyCategory>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'အမျိုးအစား',
              prefixIcon: Icon(Icons.category_outlined),
              border: OutlineInputBorder(),
            ),
            items: MoneyCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(category.icon),
                    const SizedBox(width: 10),
                    Text(_categoryName(category)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _category = value;
              });
            },
          ),

          // Title
          TextFormField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'ဘာအတွက်လဲ',
              hintText: 'ဥပမာ - ဆန်ဝယ်ခြင်း',
              prefixIcon: Icon(Icons.edit_note_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'ဘာအတွက်လဲ ကို ထည့်ပါ';
              }
              return null;
            },
          ),

          // Description
          TextFormField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              labelText: 'အသေးစိတ်',
              hintText: 'မှတ်ချက်ထည့်ရန်...',
              prefixIcon: Icon(Icons.notes_outlined),
              border: OutlineInputBorder(),
            ),
          ),

          // Date
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'ရက်စွဲ',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
              child: Text(_formatDate(_date)),
            ),
          ),

          // Save
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: Text(
                    widget.editTrans == null
                        ? 'သိမ်းမည်'
                        : 'ပြင်ဆင်ပြီး သိမ်းမည်',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _categoryName(MoneyCategory category) {
    return switch (category) {
      .salary => 'လစာ',
      .farm => 'လယ်ယာ',
      .construction => 'ဆောက်လုပ်ရေး',
      .saving => 'စုငွေ',
      .food => 'စားသောက်',
      .transport => 'သွားလာရေး',
      .shopping => 'စျေးဝယ်',
      .other => 'အခြား',
      .onlinePayment => 'Online ငွေးကြေး',
      .phoneBill => 'Phone Bill',
    };
  }
}
