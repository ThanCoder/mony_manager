import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/core/types/weight_unit.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/new_rubber_sell_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_sell/rubber_sell_detail_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_sell/rubber_sell_item_menu_sheet.dart';

class RubberSellHomePage extends StatefulWidget {
  const new({super.key, required this.site});

  final MyWorkSite site;

  @override
  State<RubberSellHomePage> createState() => _RubberSellHomePageState();
}

class _RubberSellHomePageState extends State<RubberSellHomePage> {
  // late final List<RubberSellRecord> records;

  final con = ControllerManager.read<RubberSiteController>();
  final sellCon = ControllerManager.read<RubberSellRecordController>();

  @override
  void initState() {
    super.initState();

    // records = [
    //   RubberSellRecord(
    //     id: '1',
    //     workSiteId: widget.site.id,
    //     rubberDailyWorkIds: ['work-1', 'work-2', 'work-3'],
    //     weight: 82.5,
    //     pricePerUnit: 1850,
    //     weightUnit: .pound,
    //     sellMoney: 152625,
    //     workerSellMoney: 100000,
    //     buyer: 'ဦးကျော်',
    //     note: '',
    //     date: DateTime(2026, 10, 7),
    //   ),
    //   RubberSellRecord(
    //     id: '2',
    //     workSiteId: widget.site.id,
    //     rubberDailyWorkIds: ['work-4', 'work-5'],
    //     weight: 64,
    //     pricePerUnit: 1800,
    //     weightUnit: .pound,
    //     sellMoney: 115200,
    //     workerSellMoney: 100000,
    //     buyer: 'ကိုမောင်',
    //     note: 'မနက်ပိုင်း ရောင်း',
    //     date: DateTime(2026, 10, 3),
    //   ),
    //   RubberSellRecord(
    //     id: '3',
    //     workSiteId: widget.site.id,
    //     rubberDailyWorkIds: ['work-6', 'work-7', 'work-8'],
    //     weight: 91.5,
    //     pricePerUnit: 1900,
    //     weightUnit: .pound,
    //     workerSellMoney: 100000,
    //     sellMoney: 173850,
    //     buyer: 'ဦးကျော်',
    //     note: '',
    //     date: DateTime(2026, 9, 28),
    //   ),
    // ];
  }

  double get totalMoney {
    return sellCon.list.fold(0, (sum, item) => sum + item.workerSellMoney);
  }

  double get totalWeight {
    return sellCon.list.fold(0, (sum, item) => sum + item.weight);
  }

  void _showNewRubberSellSheet() async {
    await NewRubberSellSheet.show(
      context,
      site: widget.site,
      buyerName: sellCon.list.isEmpty ? null : sellCon.list.last.buyer,
      priceWeight: sellCon.list.isEmpty ? null : sellCon.list.last.pricePerUnit,
      onSave: (resp) async {
        for (var wd in resp.dailyWorks) {
          await con.update(wd.generatedId, wd.copyWith(paid: true));
        }
        await sellCon.add(resp.record);
      },
    );
  }

  void showDetail(RubberSellRecord item) async {
    RubberSellDetailSheet.show(context, record: item);
  }

  void showItemMenu(RubberSellRecord item) async {
    RubberSellItemMenuSheet.show(context, record: item, site: widget.site);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ရော်ဘာအရောင်းစာရင်းများ')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewRubberSellSheet,
        icon: const Icon(Icons.add),
        label: const Text('အရောင်းထည့်'),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: sellCon.events.whereType<RubberSellRecordDataChanged>(),
            builder: (context, asyncSnapshot) {
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _SummaryCard(
                        totalMoney: totalMoney,
                        totalWeight: totalWeight,
                        count: sellCon.list.length,
                        unit: .pound,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'အရောင်းမှတ်တမ်း',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: StreamBuilder(
              stream: sellCon.events.whereType<RubberSellRecordDataChanged>(),
              builder: (context, asyncSnapshot) {
                if (sellCon.list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('စာရင်း မရှိပါ....')),
                  );
                }
                return SliverList.builder(
                  itemCount: sellCon.list.length,
                  itemBuilder: (context, index) {
                    final item = sellCon.list[index];
                    return GestureDetector(
                      onTap: () => showDetail(item),
                      onLongPress: () => showItemMenu(item),
                      onSecondaryTap: () => showItemMenu(item),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SellRecordCard(record: item),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalMoney,
    required this.totalWeight,
    required this.count,
    required this.unit,
  });

  final double totalMoney;
  final double totalWeight;
  final int count;
  final WeightUnit unit;

  String _money(double value) {
    return '${value.toStringAsFixed(0)} ကျပ်';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ရရှိငွေ
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'စုစုပေါင်း ရရှိငွေ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                //ရောင်းရငွေ
              ],
            ),

            const SizedBox(height: 14),

            Text(
              _money(totalMoney),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),
            const Divider(height: 1),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.scale_outlined,
                    label: 'ရောင်းထားသောအလေးချိန်',
                    value: '${totalWeight.toStringAsFixed(1)} ${unit.label}',
                  ),
                ),

                Container(
                  width: 1,
                  height: 42,
                  color: colorScheme.outlineVariant,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _SummaryItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'အရောင်းအကြိမ်',
                    value: '$count ကြိမ်',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SellRecordCard extends StatelessWidget {
  const _SellRecordCard({required this.record});

  final RubberSellRecord record;

  String _money(double value) {
    return '${value.toStringAsFixed(0)} ကျပ်';
  }

  String _date(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(child: const Icon(Icons.shopping_basket_outlined)),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.buyer,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _date(record.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                Text(
                  _money(record.sellMoney),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'အလေးချိန်',
                    value: '${record.weight} ${record.weightUnit.label}',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: '1 ${record.weightUnit.label} ဈေး',
                    value: _money(record.pricePerUnit),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'အလုပ်လုပ်ခဲ့တဲ့ နေ့ရက်များ',
                    value: record.rubberDailyWorkIds.length.toString(),
                  ),
                ),
              ],
            ),

            if (record.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  record.note,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
