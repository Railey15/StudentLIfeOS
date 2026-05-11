import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final bool embedded;

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  @override
  Widget build(BuildContext context) {
    const title = 'Academic Tracker';
    const subtitle =
        'Manage subjects, assignments, deadlines, and track your GPA.';

    final pendingTasks =
        widget.controller.academicTasks.where((t) => !t.isDone).toList();
    final completedTasks =
        widget.controller.academicTasks.where((t) => t.isDone).toList();

    final content = [
      if (widget.embedded) ...[
        const EmbeddedModuleHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 18),
      ],

      // Stats bar
      Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.school_rounded,
              label: widget.controller.currentGpa,
              caption: 'Current GPA',
              color: AppPalette.softRed,
              iconColor: AppPalette.brightRed,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.assignment_rounded,
              label: '${pendingTasks.length}',
              caption: 'Pending',
              color: AppPalette.sky,
              iconColor: AppPalette.royalBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_rounded,
              label: '${completedTasks.length}',
              caption: 'Done',
              color: AppPalette.softGreen,
              iconColor: const Color(0xFF059669),
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),

      // Action buttons
      Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: _openAddSubjectSheet,
              icon: const Icon(Icons.library_add_rounded, size: 18),
              label: const Text('Add Subject'),
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed:
                  widget.controller.subjects.isEmpty ? null : _openAddTaskSheet,
              icon: const Icon(Icons.add_task_rounded, size: 18),
              label: const Text('Add Task'),
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.royalBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),

      // Subjects section
      const SizedBox(height: 28),
      Row(
        children: [
          const Expanded(child: SectionTitle('Subjects')),
          if (widget.controller.subjects.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.sky,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.controller.subjects.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.royalBlue,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      if (widget.controller.subjects.isEmpty)
        InfoCard(
          child: Column(
            children: const [
              Icon(Icons.menu_book_rounded, size: 40, color: AppPalette.muted),
              SizedBox(height: 10),
              Text(
                'No subjects yet. Add your first subject to start tracking.',
                style: TextStyle(color: AppPalette.muted, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      for (final subject in widget.controller.subjects) ...[
        _SubjectCard(subject: subject),
        const SizedBox(height: 10),
      ],

      // Pending tasks
      const SizedBox(height: 28),
      Row(
        children: [
          const Expanded(child: SectionTitle('Pending Tasks')),
          if (pendingTasks.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.softRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${pendingTasks.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.brightRed,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      if (pendingTasks.isEmpty)
        InfoCard(
          child: Row(
            children: const [
              Icon(Icons.check_circle_rounded,
                  color: Color(0xFF059669), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'All caught up! No pending assignments.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ),
      for (final task in pendingTasks) ...[
        _TaskCard(
          task: task,
          onChanged: (v) => widget.controller.toggleAcademicTask(task, v),
        ),
        const SizedBox(height: 10),
      ],

      // Completed tasks
      if (completedTasks.isNotEmpty) ...[
        const SizedBox(height: 28),
        const SectionTitle('Completed'),
        const SizedBox(height: 12),
        for (final task in completedTasks) ...[
          _TaskCard(
            task: task,
            onChanged: (v) => widget.controller.toggleAcademicTask(task, v),
          ),
          const SizedBox(height: 10),
        ],
      ],
    ];

    if (widget.embedded) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: content,
      );
    }

    return ModulePageScaffold(
      title: title,
      subtitle: subtitle,
      accent: AppPalette.navy,
      body: content,
    );
  }

  Future<void> _openAddSubjectSheet() async {
    final codeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SheetWrapper(
        title: 'Add Subject',
        accent: AppPalette.navy,
        child: Column(
          children: [
            TextField(
              controller: codeCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'Subject code (e.g. IT 311)',
                prefixIcon: Icon(Icons.tag_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                hintText: 'Subject title',
                prefixIcon: Icon(Icons.menu_book_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: gradeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Current grade (optional)',
                prefixIcon: Icon(Icons.grade_rounded),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final code = codeCtrl.text.trim();
                  final t = titleCtrl.text.trim();
                  if (code.isEmpty || t.isEmpty) return;
                  await widget.controller.addSubject(
                    code: code,
                    title: t,
                    grade: gradeCtrl.text.trim().isEmpty
                        ? null
                        : gradeCtrl.text.trim(),
                  );
                  if (mounted) Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppPalette.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Subject'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddTaskSheet() async {
    final titleCtrl = TextEditingController();
    final detailsCtrl = TextEditingController();
    String priority = 'Medium';
    String selectedSubjectId = widget.controller.subjects.first.id;
    DateTime? selectedDeadline;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _SheetWrapper(
          title: 'Add Assignment',
          accent: AppPalette.royalBlue,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedSubjectId,
                items: widget.controller.subjects
                    .map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text('${s.code} — ${s.title}'),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setModalState(() => selectedSubjectId = v ?? ''),
                decoration: const InputDecoration(
                  hintText: 'Subject',
                  prefixIcon: Icon(Icons.menu_book_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  hintText: 'Assignment title',
                  prefixIcon: Icon(Icons.assignment_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Details (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 12),
              // Priority selector
              Row(
                children: [
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppPalette.muted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  for (final p in ['Low', 'Medium', 'High'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setModalState(() => priority = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: priority == p
                                ? _priorityColor(p)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: priority == p
                                  ? _priorityColor(p)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            p,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: priority == p
                                  ? Colors.white
                                  : AppPalette.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Deadline picker
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365)),
                    initialDate: DateTime.now(),
                  );
                  if (d == null || !mounted) return;
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (t == null) return;
                  setModalState(() {
                    selectedDeadline = DateTime(
                        d.year, d.month, d.day, t.hour, t.minute);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedDeadline != null
                        ? AppPalette.sky
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selectedDeadline != null
                          ? AppPalette.royalBlue
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        color: selectedDeadline != null
                            ? AppPalette.royalBlue
                            : AppPalette.muted,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        selectedDeadline == null
                            ? 'Set deadline (optional)'
                            : '${selectedDeadline!.month}/${selectedDeadline!.day} at ${selectedDeadline!.hour}:${selectedDeadline!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: selectedDeadline != null
                              ? AppPalette.royalBlue
                              : AppPalette.muted,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (selectedDeadline != null) ...[
                        const Spacer(),
                        GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedDeadline = null),
                          child: const Icon(Icons.close_rounded,
                              size: 16, color: AppPalette.muted),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final t = titleCtrl.text.trim();
                    if (t.isEmpty) return;
                    await widget.controller.addAcademicTask(
                      title: t,
                      details: detailsCtrl.text.trim(),
                      priority: priority,
                      subjectId: selectedSubjectId,
                      deadline: selectedDeadline,
                    );
                    if (mounted) Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPalette.royalBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Assignment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String p) {
    return switch (p) {
      'High' => AppPalette.brightRed,
      'Medium' => const Color(0xFFF59E0B),
      _ => const Color(0xFF64748B),
    };
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.caption,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            caption,
            style: const TextStyle(fontSize: 11, color: AppPalette.muted),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final SubjectRecord subject;

  @override
  Widget build(BuildContext context) {
    final hasGrade = subject.grade != '--' && subject.grade.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: AppPalette.royalBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subject.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasGrade)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppPalette.navy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subject.grade,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${(subject.progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppPalette.muted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: subject.progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation(AppPalette.royalBlue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onChanged});

  final AcademicTask task;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final priorityColor = switch (task.priority) {
      'High' => AppPalette.brightRed,
      'Medium' => const Color(0xFFF59E0B),
      _ => const Color(0xFF64748B),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: task.isDone
            ? null
            : Border.all(color: priorityColor.withValues(alpha: 0.18)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onChanged(!task.isDone),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: task.isDone ? AppPalette.royalBlue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: task.isDone
                        ? AppPalette.royalBlue
                        : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: task.isDone
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                        color: task.isDone ? AppPalette.muted : AppPalette.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Priority badge
                        if (!task.isDone) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  priorityColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              task.priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: priorityColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            task.subject,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppPalette.muted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (task.deadline != 'No deadline') ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: task.isDone
                                ? AppPalette.muted
                                : priorityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.deadline,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: task.isDone
                                  ? AppPalette.muted
                                  : priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (task.details.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppPalette.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetWrapper extends StatelessWidget {
  const _SheetWrapper({
    required this.title,
    required this.child,
    required this.accent,
  });

  final String title;
  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 22,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
