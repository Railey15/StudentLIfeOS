import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../widgets/student_widgets.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    const title = 'Campus Map';
    const subtitle =
        'Interactive campus navigation for study areas, food stalls, restrooms, and charging stations.';

    final content = [
      if (embedded) ...[
        const EmbeddedModuleHeader(
          title: title,
          subtitle: subtitle,
        ),
        const SizedBox(height: 18),
      ],
      InfoCard(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 240,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  gradient: LinearGradient(
                    colors: [Color(0xFFEAF2FF), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                left: 26,
                top: 42,
                child: _road(250, 0.22),
              ),
              Positioned(
                right: 30,
                top: 22,
                child: _road(170, -0.35),
              ),
              const Positioned(
                left: 46,
                bottom: 34,
                child: _Pin(label: 'Library', color: AppPalette.navy, icon: Icons.local_library_rounded),
              ),
              const Positioned(
                right: 34,
                top: 76,
                child: _Pin(label: 'Charging', color: AppPalette.royalBlue, icon: Icons.bolt_rounded),
              ),
              const Positioned(
                left: 136,
                top: 18,
                child: _Pin(label: 'Food', color: AppPalette.brightRed, icon: Icons.restaurant_rounded),
              ),
              const Positioned(
                right: 60,
                bottom: 24,
                child: _Pin(label: 'Study Hub', color: AppPalette.navy, icon: Icons.groups_rounded),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      const SectionTitle('Nearby places'),
      const SizedBox(height: 12),
      for (final place in controller.campusPlaces) ...[
        TimelineCard(
          title: place.name,
          subtitle: '${place.walkTime} | ${place.status}',
          meta: '${place.type} | ${place.description}',
          accent: place.type == 'Food' ? AppPalette.brightRed : AppPalette.royalBlue,
        ),
        const SizedBox(height: 12),
      ],
    ];

    if (embedded) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: content,
      );
    }

    return ModulePageScaffold(
      title: title,
      subtitle: subtitle,
      accent: AppPalette.royalBlue,
      body: content,
    );
  }

  Widget _road(double width, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
