import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/student_models.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.profile,
    required this.onProfileTap,
    required this.onSettingsTap,
  });

  final UserProfile profile;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onProfileTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [AppPalette.brightRed, AppPalette.navy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${profile.name}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                profile.greeting,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.muted,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.program} | ${profile.yearLevel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.muted,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _IconSurface(
          icon: Icons.settings_rounded,
          onTap: onSettingsTap,
        ),
      ],
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.title,
    required this.description,
    required this.badge,
  });

  final String title;
  final String description;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;

        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [AppPalette.navy, AppPalette.royalBlue, AppPalette.brightRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.navy.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroTextBlock(
                      title: title,
                      description: description,
                      badge: badge,
                    ),
                    const SizedBox(height: 18),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: DecorOrbCluster(),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _HeroTextBlock(
                        title: title,
                        description: description,
                        badge: badge,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const DecorOrbCluster(),
                  ],
                ),
        );
      },
    );
  }
}

class _HeroTextBlock extends StatelessWidget {
  const _HeroTextBlock({
    required this.title,
    required this.description,
    required this.badge,
  });

  final String title;
  final String description;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.45,
              ),
        ),
      ],
    );
  }
}

class DecorOrbCluster extends StatelessWidget {
  const DecorOrbCluster({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 140,
      child: Stack(
        children: const [
          Positioned(
            right: 10,
            top: 6,
            child: DecorOrb(
              size: 50,
              color: Color(0xFFFFD166),
              shadow: Color(0x66F59E0B),
            ),
          ),
          Positioned(
            left: 4,
            top: 36,
            child: DecorOrb(
              size: 44,
              color: AppPalette.brightRed,
              shadow: Color(0x66D72638),
            ),
          ),
          Positioned(
            right: 24,
            top: 54,
            child: DecorOrb(
              size: 34,
              color: Color(0xFFE2E8F0),
              shadow: Color(0x66CBD5E1),
            ),
          ),
          Positioned(
            left: 32,
            bottom: 8,
            child: DecorOrb(
              size: 56,
              color: Color(0xFF9CC4FF),
              shadow: Color(0x662563EB),
            ),
          ),
        ],
      ),
    );
  }
}

class DecorOrb extends StatelessWidget {
  const DecorOrb({
    super.key,
    required this.size,
    required this.color,
    required this.shadow,
  });

  final double size;
  final Color color;
  final Color shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.34),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppPalette.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class InsightStatCard extends StatelessWidget {
  const InsightStatCard({
    super.key,
    required this.metric,
    required this.color,
  });

  final InsightMetric metric;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            metric.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF475569),
                ),
          ),
        ],
      ),
    );
  }
}

class ModuleShortcutCard extends StatelessWidget {
  const ModuleShortcutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String detail;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 188),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppPalette.ink),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              detail,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF475569),
                    height: 1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String meta;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 14,
            height: 72,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.muted,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 22),
            child: Icon(Icons.chevron_right_rounded, size: 24),
          ),
        ],
      ),
    );
  }
}

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.muted,
                ),
          ),
        ],
      ),
    );
  }
}

class ModulePageScaffold extends StatelessWidget {
  const ModulePageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final List<Widget> body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          children: [
            Row(
              children: [
                _IconSurface(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const Spacer(),
                _IconSurface(
                  icon: Icons.tune_rounded,
                  iconColor: accent,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppPalette.muted,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 18),
            ...body,
          ],
        ),
      ),
    );
  }
}

class EmbeddedModuleHeader extends StatelessWidget {
  const EmbeddedModuleHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppPalette.muted,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

class SubjectProgressCard extends StatelessWidget {
  const SubjectProgressCard({
    super.key,
    required this.subject,
  });

  final SubjectRecord subject;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subject.code,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Chip(label: Text('Grade ${subject.grade}')),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subject.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: subject.progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(AppPalette.royalBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetCategoryCard extends StatelessWidget {
  const BudgetCategoryCard({
    super.key,
    required this.category,
    required this.color,
  });

  final BudgetCategory category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Text(
                category.percentLabel,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: category.progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.accent,
    required this.onMessageTap,
  });

  final Listing listing;
  final Color accent;
  final VoidCallback onMessageTap;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listing.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                listing.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _listingPlaceholder(),
              ),
            ),
            const SizedBox(height: 14),
          ] else ...[
            _listingPlaceholder(),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '${listing.listingType} | ${listing.category}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                listing.price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: accent,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            listing.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Seller: ${listing.seller}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPalette.muted,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            listing.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPalette.muted,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onMessageTap,
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Chat This Person'),
          ),
        ],
      ),
    );
  }

  Widget _listingPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.18),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_rounded, size: 42, color: AppPalette.muted),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.item,
    required this.accent,
  });

  final AnnouncementItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(label: Text(item.type)),
              const Spacer(),
              Text(
                item.date,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPalette.muted,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class ProjectBoardCard extends StatelessWidget {
  const ProjectBoardCard({
    super.key,
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<ProjectTask> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 14),
          for (final item in items) ...[
            InfoCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.owner} | ${item.deadline}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppPalette.muted,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class ArchitecturePanel extends StatelessWidget {
  const ArchitecturePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          ArchitectureLayerCard(
            title: 'Presentation Layer',
            subtitle: 'Dashboard, forms, notifications, and module views',
            color: AppPalette.sky,
            icon: Icons.phone_iphone_rounded,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
          ),
          ArchitectureLayerCard(
            title: 'Application Layer',
            subtitle: 'Controllers for auth, academics, wellness, budget, chat, and market',
            color: AppPalette.softRed,
            icon: Icons.settings_suggest_rounded,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
          ),
          ArchitectureLayerCard(
            title: 'Data Layer',
            subtitle: 'Profiles, grades, expenses, locations, listings, events, and logs',
            color: AppPalette.softGreen,
            icon: Icons.storage_rounded,
          ),
        ],
      ),
    );
  }
}

class ArchitectureLayerCard extends StatelessWidget {
  const ArchitectureLayerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF475569),
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusStrip extends StatelessWidget {
  const StatusStrip({
    super.key,
    required this.metrics,
  });

  final List<InsightMetric> metrics;

  @override
  Widget build(BuildContext context) {
    const colors = [
      AppPalette.sky,
      AppPalette.softRed,
      AppPalette.softGreen,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;
        final cards = List.generate(
          metrics.length,
          (index) => InsightStatCard(
            metric: metrics[index],
            color: colors[index % colors.length],
          ),
        );

        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i != cards.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.auto_stories_rounded, 'Academics'),
      (Icons.account_balance_wallet_rounded, 'Budget'),
      (Icons.chat_bubble_rounded, 'Chat'),
      (Icons.storefront_rounded, 'Market'),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          final compact = constraints.maxWidth < 380 || textScale > 1.0;
          final ultraCompact = constraints.maxWidth < 340 || textScale > 1.15;

          return Container(
            height: ultraCompact ? 62 : (compact ? 68 : 74),
            padding: EdgeInsets.symmetric(
              horizontal: ultraCompact ? 4 : (compact ? 6 : 10),
              vertical: ultraCompact ? 8 : (compact ? 8 : 10),
            ),
            decoration: BoxDecoration(
              color: AppPalette.deepNav,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.navy.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 4 : 8,
                          vertical: compact ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: index == i ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[i].$1,
                              size: ultraCompact ? 22 : (compact ? 20 : 22),
                              color: index == i ? AppPalette.deepNav : Colors.white,
                            ),
                            if (!ultraCompact) ...[
                              SizedBox(height: compact ? 2 : 4),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    items[i].$2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: compact ? 9 : 11,
                                      fontWeight: FontWeight.w700,
                                      color: index == i ? AppPalette.deepNav : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IconSurface extends StatelessWidget {
  const _IconSurface({
    required this.icon,
    required this.onTap,
    this.iconColor = AppPalette.ink,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
