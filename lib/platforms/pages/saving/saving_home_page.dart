import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/saving_controller.dart';
import 'package:money_manager/core/datetime_x.dart';
import 'package:money_manager/platforms/pages/saving/money_transcation_detail_sheet.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/core/models/saving/money_transcation.dart';
import 'package:money_manager/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:money_manager/platforms/pages/saving/saving_transcation_sheet.dart';
import 'package:intl/intl.dart';
import 'package:t_widgets/t_widgets.dart';

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

  final con = ControllerManager.read<SavingController>();

  @override
  void initState() {
    site = widget.site;
    con.fetchList(site.id);
    super.initState();
  }

  final currentDate = DateTime.now();

  Future<void> init() async {
    await con.fetchList(widget.site.id);
  }

  double currentBlance(List<MoneyTransaction> list) {
    double amount = 0;
    for (var val in list) {
      if (val.isIncome) {
        amount += val.amount;
      }
      if (val.isExpense) {
        amount -= val.amount;
      }
    }
    return amount;
  }

  String formatMoney(double amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(amount);
  }

  void addTranscation(MoneyTransactionType type) async {
    await SavingTranscationSheet.show(
      context,
      type: type,
      site: widget.site,
      onSaved: (trans) {
        con.add(trans);
      },
    );
  }

  void editTranscation(MoneyTransaction trans) async {
    await SavingTranscationSheet.show(
      context,
      type: trans.type,
      site: widget.site,
      editTrans: trans,
      onSaved: (update) {
        con.update(trans.generatedId, update);
      },
    );
  }

  void delTrans(MoneyTransaction trans) async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete?',
      confirmColor: col.error,
      confirmForegroundColor: col.onError,
      confirmText: 'Delete Forever!',
    );
    if (!conf) return;
    if (trans.generatedId == -1) {
      return;
    }
    con.delete(trans);
  }

  void showItemDetail(MoneyTransaction trans) async {
    MoneyTranscationDetailSheet.show(context, transaction: trans);
  }

  void showItemMenu(MoneyTransaction trans) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            children: [
              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                leading: Icon(Icons.edit_document),
                title: Text('Edit'),
                onTap: () {
                  context.pop();
                  editTranscation(trans);
                },
              ),
              ListTile(
                tileColor: col.errorContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                leading: Icon(Icons.delete_forever_outlined),
                title: Text('Delete'),
                onTap: () {
                  context.pop();
                  delTrans(trans);
                },
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (TPlatform.isDesktop)
            IconButton(onPressed: init, icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: StreamBuilder(
        stream: con.events.whereType<SavingDataChanged>(),
        builder: (context, asyncSnapshot) {
          if (con.isLoading) {
            return Center(child: TLoader.random());
          }
          return CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList.list(children: [_header]),
              SliverPadding(
                padding: .symmetric(vertical: 10, horizontal: 15),
                sliver: _transList(con.list),
              ),
            ],
          );
        },
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
                  '${formatMoney(currentBlance(con.list))} MMK',
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
                  onTap: () => addTranscation(.income),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _ActionButton(
                  icon: Icons.remove_circle_outline,
                  label: 'Expense',
                  onTap: () => addTranscation(.expense),
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

  Widget _transList(List<MoneyTransaction> list) {
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            'စာရင်း မရှိပါ...',
            style: TextStyle(fontSize: 18, fontWeight: .w600),
          ),
        ),
      );
    }
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _transListItem(list[index]),
    );
  }

  Widget _transListItem(MoneyTransaction trans) {
    final isIncome = trans.isIncome;
    // ရက်စွဲကို လှပစွာ ဖော်ပြရန် (ဥပမာ - Oct 12, 2026)
    final formattedDate = DateFormat('MMM d, yyyy').format(trans.date);

    return GestureDetector(
      onLongPress: () => showItemMenu(trans),
      onSecondaryTap: () => showItemMenu(trans),
      onTap: () => showItemDetail(trans),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            child: Icon(
              trans.category.icon,
              color: isIncome ? Colors.green : Colors.blueGrey,
            ),
          ),
          title: Text(
            trans.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans.description.isNotEmpty
                    ? trans.description
                    : trans.category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                trans.date.isToday
                    ? 'ဒီနေ့'
                    : formattedDate, // ရက်စွဲ Label ထည့်ထားခြင်း
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'}${formatMoney(trans.amount)} ကျပ်',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
              fontSize: 15,
            ),
          ),
        ),
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
