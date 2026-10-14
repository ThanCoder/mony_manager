import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/db.dart';
import 'package:t_widgets/t_widgets.dart';

class DBSettingListTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: col.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Icon(
        Icons.settings_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      title: Text('Database Setting'),
      onTap: () {
        context.pushMaterialPageRoute(builder: (mainCtx) => DBSettingPage());
      },
    );
  }
}

class DBSettingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<DBSettingPage> createState() => _DBSettingPageState();
}

class _DBSettingPageState extends State<DBSettingPage> {
  final db = DB.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Settings')),
      body: StreamBuilder(
        stream: db.events.all,
        builder: (context, asyncSnapshot) {
          return Column(
            spacing: 12,
            children: [
              StreamBuilder(
                stream: db.events.compact.all,
                builder: (context, asyncSnapshot) {
                  final needToCleanup = db.state.deletedCount > 0;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: Icon(
                      Icons.clear_all_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    trailing: !needToCleanup
                        ? null
                        : const Icon(Icons.chevron_right_rounded),
                    title: Text(
                      needToCleanup ? 'Databse Cleanup' : 'No Need To Cleanup!',
                    ),
                    subtitle: !needToCleanup
                        ? null
                        : Text(
                            'Delete Count: ${db.state.deletedCount}\nSize: ${db.state.deletedSize.fileSizeLabel()}',
                          ),
                    onTap: !needToCleanup
                        ? null
                        : () {
                            db.compact();
                          },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
