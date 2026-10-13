import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/core/datetime_x.dart';
import 'package:money_manager/core/models/rubber/rubber_daily_work.dart';

class RubberDailyWorkDetailSheet extends StatelessWidget {
  const RubberDailyWorkDetailSheet({super.key, required this.work});

  final RubberDailyWork work;

  static Future<void> show(
    BuildContext context, {
    required RubberDailyWork work,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RubberDailyWorkDetailSheet(work: work),
    );
  }

  String get _date {
    if (work.endWorkTime.isToday) {
      return 'Today';
    }

    return DateFormat('dd MMMM yyyy').format(work.endWorkTime);
  }

  String get _startTime {
    return DateFormat('hh:mm a').format(work.startWorkTime);
  }

  String get _endTime {
    return DateFormat('hh:mm a').format(work.endWorkTime);
  }

  String get _duration {
    final duration = work.endWorkTime.difference(work.startWorkTime);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '$hours နာရီ $minutes မိနစ်';
    }

    if (hours > 0) {
      return '$hours နာရီ';
    }

    return '$minutes မိနစ်';
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.agriculture_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.siteId.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Slice count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.content_cut_outlined,
                    size: 28,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${work.rubberSliceCount}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ရော်ဘာအစိတ်အပိုင်း',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Work time
            _SectionTitle(icon: Icons.schedule_outlined, title: 'အလုပ်ချိန်'),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.play_circle_outline,
                  title: 'စတင်ချိန်',
                  value: _startTime,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.stop_circle_outlined,
                  title: 'ပြီးဆုံးချိန်',
                  value: _endTime,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.timer_outlined,
                  title: 'အလုပ်လုပ်ချိန်',
                  value: _duration,
                  valueWeight: FontWeight.w700,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Work information
            _SectionTitle(icon: Icons.info_outline, title: 'အလုပ်အချက်အလက်'),

            const SizedBox(height: 10),

            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.agriculture_outlined,
                  title: 'အလုပ်နေရာ',
                  value: work.siteId.title,
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.content_cut_outlined,
                  title: 'ရော်ဘာအရေအတွက်',
                  value: '${work.rubberSliceCount} ခု',
                ),

                const Divider(height: 1),

                _InfoRow(
                  icon: Icons.event_outlined,
                  title: 'ရက်စွဲ',
                  value: _date,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Payment status
            _SectionTitle(icon: Icons.payments_outlined, title: 'ငွေပေးချေမှု'),

            const SizedBox(height: 10),

            _PaymentStatus(paid: work.paid),

            const SizedBox(height: 20),

            // Work site description
            if (work.siteId.desc.trim().isNotEmpty) ...[
              _SectionTitle(
                icon: Icons.notes_outlined,
                title: 'အလုပ်နေရာအကြောင်း',
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  work.siteId.desc,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

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
    // ignore: unused_element_parameter
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

class _PaymentStatus extends StatelessWidget {
  const _PaymentStatus({required this.paid});

  final bool paid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final background = paid
        ? colorScheme.secondaryContainer
        : colorScheme.errorContainer;

    final foreground = paid
        ? colorScheme.onSecondaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            paid ? Icons.check_circle_outline : Icons.pending_outlined,
            color: foreground,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paid ? 'ငွေရှင်းပြီး' : 'ငွေမရှင်းရသေးပါ',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  paid
                      ? 'ဒီအလုပ်အတွက် ငွေပေးချေပြီးပါပြီ'
                      : 'ဒီအလုပ်အတွက် ငွေပေးချေရန် ကျန်ရှိနေပါသေးတယ်',
                  style: theme.textTheme.bodySmall?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
