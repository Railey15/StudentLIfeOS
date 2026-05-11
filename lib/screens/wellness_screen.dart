import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../widgets/student_widgets.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  Widget build(BuildContext context) {
    return ModulePageScaffold(
      title: 'Mental Wellness',
      subtitle: 'Daily mood check-ins, emotional trend tracking, peer support, and self-care suggestions.',
      accent: AppPalette.royalBlue,
      body: [
        const InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s mood status',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Calm and steady. Your check-ins show a healthier rhythm after balancing workload and breaks.',
                style: TextStyle(color: AppPalette.muted, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Emotional trend'),
        const SizedBox(height: 12),
        InfoCard(
          child: Column(
            children: [
              for (final log in controller.wellnessLogs) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        log.day,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: log.score / 5,
                          minHeight: 12,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation(AppPalette.royalBlue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      log.mood,
                      style: const TextStyle(
                        color: AppPalette.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 52),
                    child: Text(
                      log.note,
                      style: const TextStyle(color: AppPalette.muted),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Support system'),
        const SizedBox(height: 12),
        const TimelineCard(
          title: 'Anonymous peer support',
          subtitle: 'Open safe conversation space',
          meta: 'Connect with fellow students for light check-ins and encouragement.',
          accent: AppPalette.brightRed,
        ),
        const SizedBox(height: 12),
        const TimelineCard(
          title: 'Self-care recommendation',
          subtitle: '10-minute reset routine',
          meta: 'Hydrate, stretch, and take a short walk before your next study block.',
          accent: AppPalette.royalBlue,
        ),
      ],
    );
  }
}
