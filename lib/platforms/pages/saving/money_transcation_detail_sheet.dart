import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/core/models/saving/money_transcation.dart';

class MoneyTranscationDetailSheet extends StatelessWidget {
  const MoneyTranscationDetailSheet({
    super.key,
    required this.transaction,
  });

  final MoneyTransaction transaction;

  static Future<void> show(
    BuildContext context, {
    required MoneyTransaction transaction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return MoneyTranscationDetailSheet(
          transaction: transaction,
        );
      },
    );
  }

  String get _amount {
    return '${NumberFormat('#,##0.##').format(transaction.amount)} ကျပ်';
  }

  String get _date {
    return DateFormat(
      'dd MMMM yyyy, hh:mm a',
    ).format(transaction.date);
  }

  String get _typeName {
    return transaction.isIncome ? 'ငွေဝင်' : 'ငွေထွက်';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isIncome = transaction.isIncome;

    final mainColor = isIncome
        ? colorScheme.primary
        : colorScheme.error;

    final containerColor = isIncome
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final onContainerColor = isIncome
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(
                  bottom: 20,
                ),
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    transaction.category.icon,
                    color: onContainerColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _date,
                        style:
                            theme.textTheme.bodySmall?.copyWith(
                          color:
                              colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 28,
                    color: onContainerColor,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _amount,
                    style:
                        theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: onContainerColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _typeName,
                    style:
                        theme.textTheme.bodyMedium?.copyWith(
                      color: onContainerColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Transaction information
            _SectionTitle(
              icon: Icons.receipt_long_outlined,
              title: 'ငွေစာရင်းအချက်အလက်',
            ),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: transaction.category.icon,
                  title: 'အမျိုးအစား',
                  value: transaction.category.name,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: isIncome
                      ? Icons.south_west_outlined
                      : Icons.north_east_outlined,
                  title: 'အမျိုးအစား',
                  value: _typeName,
                  valueColor: mainColor,
                  valueWeight: FontWeight.w700,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.payments_outlined,
                  title: 'ပမာဏ',
                  value: _amount,
                  valueColor: mainColor,
                  valueWeight: FontWeight.w700,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'ရက်စွဲ',
                  value: _date,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Title
            _SectionTitle(
              icon: Icons.label_outline,
              title: 'ခေါင်းစဉ်',
            ),

            const SizedBox(height: 10),

            _TextCard(
              child: Text(
                transaction.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Description
            if (transaction.description.trim().isNotEmpty) ...[
              const SizedBox(height: 20),

              _SectionTitle(
                icon: Icons.notes_outlined,
                title: 'အသေးစိတ်',
              ),

              const SizedBox(height: 10),

              _TextCard(
                child: Text(
                  transaction.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Transaction ID
            _SectionTitle(
              icon: Icons.fingerprint_outlined,
              title: 'မှတ်တမ်းအချက်အလက်',
            ),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.tag_outlined,
                  title: 'Transaction ID',
                  value: transaction.id,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.folder_outlined,
                  title: 'Site ID',
                  value: transaction.siteId,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: children,
      ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: colorScheme.onSurfaceVariant,
          ),

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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight:
                    valueWeight ?? FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}