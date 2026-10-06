import 'package:flutter/material.dart';
import 'package:money_manager/core/models/my_work_site.dart';

class SavingHomePage extends StatefulWidget {
  const new({super.key, required this.site});
  final MyWorkSite site;

  @override
  State<SavingHomePage> createState() => _SavingHomePageState();
}

class _SavingHomePageState extends State<SavingHomePage> {
  ThemeData get theme => Theme.of(context);
  ColorScheme get colorScheme => theme.colorScheme;
  late MyWorkSite site;

  @override
  void initState() {
    site = widget.site;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverList.list(children: [_header]),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        // SizedBox(width: 80),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
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
              Text(
                site.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                site.type.typeName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _header {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _appbar(),
          const SizedBox(height: 24),
          // Balance
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Current Balance',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '500,000 MMK',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Income',
                  onTap: () {
                    // Add income
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _ActionButton(
                  icon: Icons.remove_circle_outline,
                  label: 'Expense',
                  onTap: () {
                    // Add expense
                  },
                ),
              ),
            ],
          ),

          // const SizedBox(height: 12),

          // OutlinedButton.icon(
          //   onPressed: () {
          //     // Open transactions
          //   },
          //   icon: const Icon(Icons.receipt_long_outlined),
          //   label: const Text('View Transactions'),
          //   style: OutlinedButton.styleFrom(
          //     minimumSize: const Size.fromHeight(50),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
    );
  }
}
