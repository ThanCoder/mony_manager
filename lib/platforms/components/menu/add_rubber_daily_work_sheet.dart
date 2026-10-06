import 'package:flutter/material.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/my_work_site.dart';

class AddRubberDailyWorkSheet extends StatefulWidget {
  const AddRubberDailyWorkSheet({
    super.key,
    required this.sites,
    required this.workers,
    this.onSave,
  });

  final List<MyWorkSite> sites;
  final List<String> workers;
  final void Function(RubberDailyWork work)? onSave;

  static Future<void> show(
    BuildContext context, {
    required List<MyWorkSite> sites,
    required List<String> workers,
    void Function(RubberDailyWork work)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return AddRubberDailyWorkSheet(
          sites: sites,
          workers: workers,
          onSave: onSave,
        );
      },
    );
  }

  @override
  State<AddRubberDailyWorkSheet> createState() =>
      _AddRubberDailyWorkSheetState();
}

class _AddRubberDailyWorkSheetState extends State<AddRubberDailyWorkSheet> {
  final _formKey = GlobalKey<FormState>();

  final _sliceController = TextEditingController();

  MyWorkSite? _siteId;
  String? _workerId;

  DateTime _startWorkTime = DateTime.now();
  DateTime _endWorkTime = DateTime.now();

  @override
  void dispose() {
    _sliceController.dispose();
    super.dispose();
  }

  Future<void> _selectTime({required bool start}) async {
    final current = start ? _startWorkTime : _endWorkTime;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );

    if (time == null || !mounted) return;

    final value = DateTime(
      current.year,
      current.month,
      current.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (start) {
        _startWorkTime = value;
      } else {
        _endWorkTime = value;
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_siteId == null || _workerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select site and worker')),
      );
      return;
    }

    if (!_endWorkTime.isAfter(_startWorkTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final work = RubberDailyWork(
      siteId: _siteId!,
      workerId: _workerId!,
      startWorkTime: _startWorkTime,
      endWorkTime: _endWorkTime,
      rubberSliceCount: int.parse(_sliceController.text),
    );

    widget.onSave?.call(work);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Daily Work',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<MyWorkSite>(
                initialValue: _siteId,
                decoration: const InputDecoration(
                  labelText: 'Work Site',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final site in widget.sites)
                    DropdownMenuItem(value: site, child: Text(site.title)),
                ],
                onChanged: (value) {
                  setState(() {
                    _siteId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Select a work site';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _workerId,
                decoration: const InputDecoration(
                  labelText: 'Worker',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final id in widget.workers)
                    DropdownMenuItem(value: id, child: Text(id)),
                ],
                onChanged: (value) {
                  setState(() {
                    _workerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Select a worker';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Work Time',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _TimeCard(
                      title: 'Start',
                      time: _startWorkTime,
                      icon: Icons.login_rounded,
                      onTap: () => _selectTime(start: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeCard(
                      title: 'End',
                      time: _endWorkTime,
                      icon: Icons.logout_rounded,
                      onTap: () => _selectTime(start: false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _sliceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rubber Slices',
                  hintText: 'Enter number of rubber slices',
                  prefixIcon: Icon(Icons.format_list_numbered),
                  suffixText: 'slices',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter rubber slice count';
                  }

                  final count = int.tryParse(value);

                  if (count == null || count < 0) {
                    return 'Enter a valid number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Save Work'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String title;
  final DateTime time;
  final IconData icon;
  final VoidCallback onTap;

  const _TimeCard({
    required this.title,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timeText = TimeOfDay.fromDateTime(time).format(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
