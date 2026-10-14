import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';

class RubberSellDetailSheet extends StatelessWidget {
  const RubberSellDetailSheet({super.key, required this.record});

  final RubberSellRecord record;

  static Future<void> show(
    BuildContext context, {
    required RubberSellRecord record,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RubberSellDetailSheet(record: record),
    );
  }

  String get _money {
    return '${NumberFormat('#,##0').format(record.sellMoney)} ကျပ်';
  }

  String get _workerMoney {
    return '${NumberFormat('#,##0').format(record.workerSellMoney)} ကျပ်';
  }

  String get _price {
    return '${NumberFormat('#,##0.##').format(record.pricePerUnit)} ကျပ်';
  }

  String get _weight {
    return '${NumberFormat('#,##0.##').format(record.weight)} ${record.weightUnit.symbol}';
  }

  String get _date {
    return DateFormat('dd MMMM yyyy, hh:mm a').format(record.date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sell_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.buyer.isEmpty ? 'Rubber Sale' : record.buyer,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Total Sale Money
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'ရောင်းရငွေ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _money,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sale information
            _SectionTitle(
              title: 'အရောင်းအချက်အလက်',
              icon: Icons.receipt_long_outlined,
            ),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.scale_outlined,
                  title: 'အလေးချိန်',
                  value: _weight,
                ),
                const Divider(height: 1),
                _InfoRow(
                  icon: Icons.price_check_outlined,
                  title: 'တစ်ယူနစ်ဈေး',
                  value: _price,
                ),
                const Divider(height: 1),
                _InfoRow(
                  icon: Icons.calculate_outlined,
                  title: 'တွက်ချက်မှု',
                  value: '$_weight × $_price',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Money distribution
            _SectionTitle(
              title: 'ငွေခွဲဝေမှု',
              icon: Icons.account_balance_wallet_outlined,
            ),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.store_outlined,
                  title: 'စုစုပေါင်းရောင်းရငွေ',
                  value: _money,
                  valueWeight: FontWeight.w700,
                ),
                const Divider(height: 1),
                _InfoRow(
                  icon: Icons.groups_outlined,
                  title: 'လုပ်သားများရရှိငွေ',
                  value: _workerMoney,
                  valueColor: colorScheme.secondary,
                  valueWeight: FontWeight.w700,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Work records
            _SectionTitle(
              title: 'အလုပ်မှတ်တမ်း',
              icon: Icons.work_history_outlined,
            ),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.format_list_numbered_outlined,
                  title: 'နေ့စဉ်အလုပ်မှတ်တမ်း',
                  value: '${record.rubberDailyWorkIds.length} ခု',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Note
            if (record.note.trim().isNotEmpty) ...[
              _SectionTitle(title: 'မှတ်ချက်', icon: Icons.notes_outlined),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  record.note,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),

              const SizedBox(height: 20),
            ],

            // Buyer
            if (record.buyer.trim().isNotEmpty) ...[
              _SectionTitle(title: 'ဝယ်သူ', icon: Icons.person_outline),
              const SizedBox(height: 10),

              _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: 'ဝယ်သူအမည်',
                    value: record.buyer,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.valueWeight,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final FontWeight? valueWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 21, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: valueWeight ?? FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
