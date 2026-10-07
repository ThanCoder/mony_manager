import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/core/work_site_data.dart';
import 'package:money_manager/platforms/components/menu/add_rubber_daily_work_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_item_menu.dart';

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

  final con = ControllerManager.read<RubberSiteController>();
  final currentDate = DateTime.now();
  int? get currentDayRubberSlice {
    for (var d in con.list) {
      if (d.endWorkTime.month == currentDate.month &&
          d.endWorkTime.day == currentDate.day) {
        return d.rubberSliceCount;
      }
    }
    return null;
  }

  int get unpaidRubberSlices {
    return con.list.fold(0, (prev, ele) {
      if (!ele.paid) {
        return prev + ele.rubberSliceCount;
      }
      return 0;
    });
  }

  List<Widget> get headerList => [
    // _SummaryCard(
    //   icon: Icons.people_outline,
    //   title: 'အလုပ်သမားများ',
    //   value: '12',
    // ),
    if (currentDayRubberSlice != null)
      _SummaryCard(
        icon: Icons.eco_outlined,
        title: 'ဒီနေ့ အစီးပြား',
        value: currentDayRubberSlice.toString(),
        suffix: ' slices',
      ),
    _SummaryCard(
      icon: Icons.eco_outlined,
      title: 'မရောင်းရသေးတဲ့ အစီးပြား',
      value: unpaidRubberSlices.toString(),
      suffix: ' slices',
    ),
    _SummaryCard(
      icon: Icons.calendar_month_outlined,
      title: 'အလုပ်လုပ်ခဲ့တဲ့နေ့',
      value: '${con.list.length}',
    ),

    InkWell(
      borderRadius: .circular(18),
      onTap: () {},
      child: _SummaryCard(
        icon: Icons.payments_outlined,
        title: 'အရင်အပတ်က ဝင်ငွေ',
        value: '0',
        suffix: ' MMK >',
      ),
    ),
    // _SummaryCard(
    //   icon: Icons.payments_outlined,
    //   title: 'ဝင်ငွေအားလုံး',
    //   value: '450,000',
    //   suffix: ' MMK',
    // ),
  ];

  void _showAddDailyWork(BuildContext context) {
    AddRubberDailyWorkSheet.show(
      context,
      sites: [site],
      workers: workers,
      onSave: (work) {
        con.add(work);
      },
    );
  }

  void showMenu() {}
  void showRubberDetail(RubberDailyWork work) {}
  void showRubberItemMenu(RubberDailyWork work) {
    RubberItemMenu.show(context, work,site: widget.site);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.site.title),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: con.fetchList,
              icon: const Icon(Icons.refresh_rounded),
            ),
          IconButton(onPressed: showMenu, icon: const Icon(Icons.more_vert)),
        ],
      ),

      body: RefreshIndicator.adaptive(
        onRefresh: con.fetchList,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _header(theme),
            ),

            // Daily work list
            _listWidget(),
            SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
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

  SliverToBoxAdapter _header(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          StreamBuilder(
            stream: con.events.whereType<RubberSiteDataChanged>(),
            builder: (context, asyncSnapshot) {
              return Wrap(spacing: 12, runSpacing: 12, children: headerList);
            },
          ),

          const SizedBox(height: 12),

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
    );
  }

  Widget _listWidget() {
    return StreamBuilder(
      stream: con.events.whereType<RubberSiteDataChanged>(),
      builder: (context, asyncSnapshot) {
        if (con.list.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text('စာရင်းမရှိပါ')),
          );
        }
        return SliverList.builder(
          itemCount: con.list.length,
          itemBuilder: (context, index) {
            return _dailyWorkItem(con.list[index]);
          },
        );
      },
    );
  }

  Widget _dailyWorkItem(RubberDailyWork rubber) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showRubberDetail(rubber),
        onLongPress: () => showRubberItemMenu(rubber),
        onSecondaryTap: () => showRubberItemMenu(rubber),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: rubber.paid
                ? colorScheme.surfaceContainer
                : const Color.fromARGB(255, 37, 95, 39),
            borderRadius: .circular(14),
          ),
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
                      rubber.workerId,
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
                    Text(rubber.date),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${rubber.rubberSliceCount}',
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
