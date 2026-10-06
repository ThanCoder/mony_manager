import 'package:flutter/material.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/platforms/components/menu/add_rubber_daily_work_sheet.dart';

class RubberHomePage extends StatefulWidget {
  const new({super.key, required this.site});

  final MyWorkSite site;

  @override
  State<RubberHomePage> createState() => _RubberHomePageState();
}

class _RubberHomePageState extends State<RubberHomePage> {
  late MyWorkSite site;
  @override
  void initState() {
    site = widget.site;
    super.initState();
  }

  void _showAddDailyWork(BuildContext context) {
    AddRubberDailyWorkSheet.show(
      context,
      sites: [site],
      workers: const ['Worker 1', 'Worker 2', 'Worker 3'],
      onSave: (work) {
        // Save to DualStore
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.site.title),
        actions: [
          IconButton(
            onPressed: () {
              // Site settings
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.people_outline,
                          title: 'Workers',
                          value: '12',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.eco_outlined,
                          title: 'Today',
                          value: '850',
                          suffix: ' slices',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Work Days',
                          value: '24',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.payments_outlined,
                          title: 'Income',
                          value: '450,000',
                          suffix: ' MMK',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Text(
                        'Daily Work',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // View all
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Daily work list
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return _dailyWorkItem(context, index);
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddDailyWork(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Daily Work'),
      ),
    );
  }

  Widget _dailyWorkItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Open daily work detail
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.eco_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Worker ${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '06:30 AM  →  11:30 AM',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text('2026-10-11'),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${650 + index * 20}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'slices',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String suffix;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),

          const SizedBox(height: 12),

          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(text: value),
                if (suffix.isNotEmpty)
                  TextSpan(
                    text: suffix,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
