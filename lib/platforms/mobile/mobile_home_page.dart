import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/my_work_site_controller.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/core/utils/app_util.dart';
import 'package:money_manager/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:money_manager/platforms/components/menu/new_work_site_sheet.dart';
import 'package:money_manager/routes.dart';

class MobileHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  void initState() {
    con.fetchList();
    super.initState();
  }

  final con = ControllerManager.read<MyWorkSiteController>();

  void createSite() async {
    NewWorkSiteSheet.show(
      context,
      onSave: (site) {
        con.add(site);
      },
    );
  }

  void goSite(MyWorkSite site) {
    goAutoMyWorkSite(context, site: site);
  }

  void _editSite(MyWorkSite site) async {
    NewWorkSiteSheet.show(
      context,
      editSite: site,
      onSave: (updatedSite) {
        con.update(site.generatedId, updatedSite);
      },
    );
  }

  void _deleteSite(MyWorkSite site) async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete?',
      confirmText: 'Delete Forever!',
      confirmColor: col.error,
      confirmForegroundColor: col.onError,
    );
    if (!conf) return;
    await con.delete(site);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUtil.instance.appName),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: con.fetchList,
              icon: Icon(Icons.refresh_outlined),
            ),
        ],
      ),
      body: StreamBuilder(
        stream: con.events.whereType<MyWorkSiteDataChanged>(),
        builder: (context, asyncSnapshot) {
          return _body;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createSite,
        child: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget get _body {
    if (con.list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 4,
          children: [
            Text('List Empty Want To Create'),
            IconButton(
              onPressed: createSite,
              icon: Icon(Icons.add_circle_outline, size: 30),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator.adaptive(
      onRefresh: con.fetchList,
      child: ListView.builder(
        itemCount: con.list.length,
        itemBuilder: (context, index) => _listItem(con.list[index]),
      ),
    );
  }

  Widget _listItem(MyWorkSite site) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => goSite(site),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  site.type.typeIcon,
                  color: colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            site.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        _popupItemMenu(site),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 6,
                      children: [
                        _chip(
                          icon: site.type.typeIcon,
                          label: site.type.typeName,
                        ),
                        if (site.role != .none)
                          _chip(
                            icon: Icons.person_outline,
                            label: site.role.roleName,
                          ),
                      ],
                    ),

                    if (site.desc.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        site.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    Text(
                      _formatDate(site.createDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> _popupItemMenu(MyWorkSite site) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
          onTap: () => _editSite(site),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
          onTap: () => _deleteSite(site),
        ),
      ],
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
