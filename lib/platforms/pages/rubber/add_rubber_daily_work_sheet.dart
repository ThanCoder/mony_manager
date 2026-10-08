import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/core/models/farm/rubber.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:uuid/v4.dart';

class AddRubberDailyWorkSheet extends StatefulWidget {
  const AddRubberDailyWorkSheet({
    super.key,
    required this.sites,
    this.onSave,
    this.work,
  });
  final RubberDailyWork? work;
  final List<MyWorkSite> sites;
  final void Function(RubberDailyWork work)? onSave;

  static Future<void> show(
    BuildContext context, {
    required List<MyWorkSite> sites,
    required List<String> workers,
    void Function(RubberDailyWork work)? onSave,
    RubberDailyWork? work,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return AddRubberDailyWorkSheet(
          sites: sites,
          onSave: onSave,
          work: work,
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
  RubberDailyWork? work;
  MyWorkSite? _siteId;
  bool paid = false;

  DateTime _startWorkTime = DateTime.now().copyWith(hour: 3, minute: 30);
  DateTime _endWorkTime = DateTime.now().copyWith(hour: 8, minute: 30);
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    final work = widget.work;
    if (work != null) {
      this.work = work;

      paid = work.paid;
      _siteId = work.siteId;

      _startWorkTime = work.startWorkTime;
      _endWorkTime = work.endWorkTime;
      _currentDate = work.endWorkTime;
      _sliceController.text = work.rubberSliceCount.toString();
    } else {
      if (widget.sites.isNotEmpty) {
        _siteId = widget.sites.first;
      }
    }
    super.initState();
  }

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

  void _chooseDate() async {
    final res = await showDatePicker(
      context: context,
      initialDate: _endWorkTime,
      currentDate: _currentDate,
      firstDate: .new(2026),
      lastDate: _endWorkTime,
    );
    if (res == null) return;
    if (!mounted) return;
    setState(() {
      _currentDate = res;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_siteId == null) {
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

    if (work != null) {
      widget.onSave?.call(
        work!.copyWith(
          siteId: _siteId!,
          startWorkTime: _currentDate.copyWith(
            hour: _startWorkTime.hour,
            minute: _startWorkTime.minute,
          ),
          endWorkTime: _currentDate.copyWith(
            hour: _endWorkTime.hour,
            minute: _endWorkTime.minute,
          ),
          rubberSliceCount: int.parse(_sliceController.text),
          paid: paid,
        ),
      );
    }
    // new
    else {
      final work = RubberDailyWork(
        id: UuidV4().generate(),
        siteId: _siteId!,

        startWorkTime: _currentDate.copyWith(
          hour: _startWorkTime.hour,
          minute: _startWorkTime.minute,
        ),
        endWorkTime: _currentDate.copyWith(
          hour: _endWorkTime.hour,
          minute: _endWorkTime.minute,
        ),
        rubberSliceCount: int.parse(_sliceController.text),
        paid: paid,
      );

      widget.onSave?.call(work);
    }

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
              if (widget.work == null)
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

              const SizedBox(height: 20),

              Text(
                'Work Time',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              ListTile(
                tileColor: colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                title: Text('ရက်စွဲ: ${_currentDate.formatTimeAgo()}'),
                onTap: _chooseDate,
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              SwitchListTile.adaptive(
                title: Text('အစီးပြား ရောင်းပြီးပြီလား'),
                value: paid,
                onChanged: (value) {
                  setState(() {
                    paid = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(work != null ? 'Update Work' : 'Save Work'),
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
