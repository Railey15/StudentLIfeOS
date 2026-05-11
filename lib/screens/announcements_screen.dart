import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../widgets/student_widgets.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  Widget build(BuildContext context) {
    return ModulePageScaffold(
      title: 'Announcements and Events',
      subtitle: 'School advisories, upcoming events, reminders, and bookmark-ready campus updates.',
      accent: AppPalette.brightRed,
      body: [
        const InfoCard(
          child: Row(
            children: [
              Expanded(
                child: ProgressSummaryCard(
                  label: 'Unread',
                  value: '3',
                  caption: 'new campus updates',
                  color: AppPalette.softRed,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProgressSummaryCard(
                  label: 'Saved',
                  value: '5',
                  caption: 'bookmarked events',
                  color: AppPalette.sky,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Latest updates'),
        const SizedBox(height: 12),
        for (var i = 0; i < controller.announcements.length; i++) ...[
          AnnouncementCard(
            item: controller.announcements[i],
            accent: i.isEven ? AppPalette.brightRed : AppPalette.royalBlue,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
