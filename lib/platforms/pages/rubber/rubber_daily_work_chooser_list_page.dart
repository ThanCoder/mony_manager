import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_daily_work.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:t_widgets/t_widgets.dart';

class RubberDailyWorkChooserListPage extends StatefulWidget {
  const new({super.key, required this.site, this.oldValues});
  final MyWorkSite site;
  final List<RubberDailyWork>? oldValues;

  @override
  State<RubberDailyWorkChooserListPage> createState() =>
      _RubberDailyWorkChooserListPageState();
}

class _RubberDailyWorkChooserListPageState
    extends State<RubberDailyWorkChooserListPage> {
  final con = ControllerManager.read<RubberSiteController>();

  final choosed = <String, RubberDailyWork>{};

  void choose() async {
    final res = choosed.values.toList();
    context.pop(res);
  }

  @override
  void initState() {
    final list = widget.oldValues;
    if (list != null && list.isNotEmpty) {
      for (var val in list) {
        choosed[val.id] = val;
      }
    } else {
      for (var val in con.list) {
        if (!val.paid) {
          choosed[val.id] = val;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ရော်ဘာ အလုပ်လုပ်ခဲ့တဲ့ နေ့စဥ်စာရင်း')),
      floatingActionButton: FloatingActionButton(
        onPressed: choose,
        child: Icon(Icons.price_check),
      ),
      body: CustomScrollView(slivers: [_listWidget()]),
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

  Widget _checkWidget(RubberDailyWork rubber) {
    return Checkbox.adaptive(
      value: choosed.keys.contains(rubber.id),
      onChanged: (value) {
        if (value!) {
          choosed[rubber.id] = rubber;
        } else {
          choosed.remove(rubber.id);
        }
        setState(() {});
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
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: rubber.paid
                ? colorScheme.surfaceContainer
                : colorScheme.primaryContainer,
            borderRadius: .circular(14),
          ),
          child: Row(
            children: [
              _checkWidget(rubber),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.eco_outlined,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   rubber.workerId,
                    //   style: theme.textTheme.titleMedium?.copyWith(
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),

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
