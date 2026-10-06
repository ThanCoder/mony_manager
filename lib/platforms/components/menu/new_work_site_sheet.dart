import 'package:flutter/material.dart';
import 'package:money_manager/core/models/my_work_site.dart';
import 'package:money_manager/core/models/work_site.dart';
import 'package:uuid/v4.dart';

class NewWorkSiteSheet extends StatefulWidget {
  final void Function(MyWorkSite site)? onSave;

  const NewWorkSiteSheet({super.key, this.onSave});

  static Future<void> show(
    BuildContext context, {
    void Function(MyWorkSite site)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return NewWorkSiteSheet(onSave: onSave);
      },
    );
  }

  @override
  State<NewWorkSiteSheet> createState() => _NewWorkSiteSheetState();
}

class _NewWorkSiteSheetState extends State<NewWorkSiteSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  WorkSiteType _type = WorkSiteType.construction;
  WorkRole _role = WorkRole.worker;

  DateTime _createDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _createDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date == null || !mounted) return;

    setState(() {
      _createDate = date;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final site = MyWorkSite(
      id: UuidV4().generate(),
      title: _titleController.text.trim(),
      type: _type,
      role: _role,
      desc: _descController.text.trim(),
      createDate: _createDate,
    );

    widget.onSave?.call(site);

    Navigator.pop(context);
  }

  String _typeName(WorkSiteType type) {
    return type.typeName;
  }

  String _roleName(WorkRole role) {
    return role.roleName;
  }

  IconData _typeIcon(WorkSiteType type) {
    return switch (type) {
      WorkSiteType.construction => Icons.construction_outlined,
      WorkSiteType.rubber => Icons.eco_outlined,
      WorkSiteType.farm => Icons.agriculture_outlined,
      WorkSiteType.saving => Icons.savings_outlined,
      .none => Icons.no_accounts,
    };
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
                'New Work Site',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter work site name',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a title';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Work Site Type
              DropdownButtonFormField<WorkSiteType>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Work Site Type',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final type in WorkSiteType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(_typeIcon(type), size: 20),
                          const SizedBox(width: 10),
                          Text(_typeName(type)),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _type = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Role
              DropdownButtonFormField<WorkRole>(
                initialValue: _role,
                decoration: const InputDecoration(
                  labelText: 'Your Role',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final role in WorkRole.values)
                    DropdownMenuItem(value: role, child: Text(_roleName(role))),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _role = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Create Date
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Create Date',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${_createDate.day.toString().padLeft(2, '0')}/'
                    '${_createDate.month.toString().padLeft(2, '0')}/'
                    '${_createDate.year}',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                minLines: 3,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe this work site...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.description_outlined),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Save
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.add),
                label: const Text('Create Work Site'),
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
