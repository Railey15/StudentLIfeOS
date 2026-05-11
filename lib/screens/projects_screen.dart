import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../widgets/student_widgets.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  Widget build(BuildContext context) {
    final todo = controller.projectTasks.where((item) => item.status == 'To Do').toList();
    final progress = controller.projectTasks.where((item) => item.status == 'In Progress').toList();
    final done = controller.projectTasks.where((item) => item.status == 'Done').toList();

    return ModulePageScaffold(
      title: 'Group Project Manager',
      subtitle: 'Kanban-style task tracking, contribution visibility, deadlines, and team coordination.',
      accent: AppPalette.navy,
      body: [
        const InfoCard(
          child: Row(
            children: [
              Expanded(
                child: ProgressSummaryCard(
                  label: 'Boards',
                  value: '2',
                  caption: 'active this week',
                  color: AppPalette.sky,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProgressSummaryCard(
                  label: 'Contribution',
                  value: '34%',
                  caption: 'your share this sprint',
                  color: AppPalette.softGreen,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Task board'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ProjectBoardCard(
                title: 'To Do',
                items: todo,
                color: AppPalette.softRed,
              ),
              const SizedBox(width: 14),
              ProjectBoardCard(
                title: 'In Progress',
                items: progress,
                color: AppPalette.sky,
              ),
              const SizedBox(width: 14),
              ProjectBoardCard(
                title: 'Done',
                items: done,
                color: AppPalette.softGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
