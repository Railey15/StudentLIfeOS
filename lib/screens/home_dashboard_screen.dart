import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../widgets/student_widgets.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
    required this.controller,
    required this.onOpenModule,
    required this.onOpenProfile,
    required this.onOpenSettings,
  });

  final StudentLifeController controller;
  final ValueChanged<StudentModule> onOpenModule;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final topTask = controller.academicTasks.isNotEmpty
        ? controller.academicTasks.firstWhere(
            (t) => !t.isDone,
            orElse: () => controller.academicTasks.first,
          )
        : null;
    final topCategory = controller.budgetCategories.isNotEmpty
        ? controller.budgetCategories.first
        : null;
    final latestChat =
        controller.chatThreads.isNotEmpty ? controller.chatThreads.first : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                DashboardHeader(
                  profile: controller.profile,
                  onProfileTap: onOpenProfile,
                  onSettingsTap: onOpenSettings,
                ),
                const SizedBox(height: 20),

                // Hero banner
                const _HeroBannerWithLogo(),
                const SizedBox(height: 24),

                // Quick stats
                const _SectionHeader(title: "Today's Snapshot"),
                const SizedBox(height: 12),
                _QuickStats(controller: controller),
                const SizedBox(height: 24),

                // Module grid
                const _SectionHeader(title: 'Modules'),
                const SizedBox(height: 12),
                _ModuleGrid(
                  controller: controller,
                  onOpenModule: onOpenModule,
                ),
                const SizedBox(height: 24),

                // Live summary
                const _SectionHeader(title: 'Live Summary'),
                const SizedBox(height: 12),

                // Top task
                if (topTask != null)
                  _SummaryTile(
                    icon: topTask.isDone
                        ? Icons.check_circle_rounded
                        : Icons.assignment_rounded,
                    iconColor: topTask.isDone
                        ? const Color(0xFF059669)
                        : (topTask.priority == 'High'
                            ? AppPalette.brightRed
                            : AppPalette.royalBlue),
                    title: topTask.title,
                    subtitle: topTask.deadline,
                    meta: '${topTask.subject} · ${topTask.priority} priority',
                    onTap: () => onOpenModule(StudentModule.academics),
                  )
                else
                  _SummaryTile(
                    icon: Icons.assignment_outlined,
                    iconColor: AppPalette.muted,
                    title: 'No tasks yet',
                    subtitle: 'Add your first assignment',
                    meta: 'Tap to open Academics',
                    onTap: () => onOpenModule(StudentModule.academics),
                  ),
                const SizedBox(height: 10),

                // Budget summary
                _SummaryTile(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: AppPalette.royalBlue,
                  title: topCategory != null
                      ? '${topCategory.name} budget'
                      : 'Budget tracker ready',
                  subtitle: controller.remainingBudgetLabel,
                  meta: topCategory != null
                      ? 'PHP ${topCategory.spentAmount.toStringAsFixed(0)} spent of PHP ${topCategory.plannedAmount.toStringAsFixed(0)} planned'
                      : 'Set your budget to start tracking',
                  onTap: () => onOpenModule(StudentModule.budget),
                ),
                const SizedBox(height: 10),

                // Latest chat
                _SummaryTile(
                  icon: Icons.chat_bubble_rounded,
                  iconColor: AppPalette.navy,
                  title:
                      latestChat != null ? latestChat.counterpartName : 'Chat inbox',
                  subtitle:
                      latestChat != null ? latestChat.lastActivity : 'No active conversations',
                  meta: latestChat != null
                      ? latestChat.lastMessage
                      : 'Message sellers or chat with other students',
                  onTap: () => onOpenModule(StudentModule.chat),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroBannerWithLogo extends StatelessWidget {
  const _HeroBannerWithLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppPalette.navy.withValues(alpha: 0.30),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background gradient + text content
            Container(
              padding: const EdgeInsets.fromLTRB(24, 26, 140, 26),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF050D1C), Color(0xFF091830), AppPalette.navy],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Student Life OS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Stay ahead in school, budget, and campus life.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deadlines, spending, chats, and marketplace — all in one place.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Logo as large watermark on the right
            Positioned(
              right: -28,
              top: -12,
              bottom: -12,
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.22,
                  child: Image.asset(
                    'lib/logo/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.controller});

  final StudentLifeController controller;

  @override
  Widget build(BuildContext context) {
    final pending = controller.dueTaskCount;
    final remaining = controller.remainingBudgetLabel;
    final chats = controller.chatThreads.length;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.assignment_rounded,
            value: '$pending',
            label: 'Tasks Due',
            color: pending > 0 ? AppPalette.softRed : AppPalette.softGreen,
            valueColor:
                pending > 0 ? AppPalette.brightRed : const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            icon: Icons.account_balance_wallet_rounded,
            value: remaining,
            label: 'Budget Left',
            color: AppPalette.sky,
            valueColor: AppPalette.royalBlue,
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            icon: Icons.chat_bubble_rounded,
            value: '$chats',
            label: 'Chats',
            color: const Color(0xFFF3F0FF),
            valueColor: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.valueColor,
    this.compact = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: valueColor, size: 18),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: compact ? 13 : 18,
                color: valueColor,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppPalette.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({
    required this.controller,
    required this.onOpenModule,
  });

  final StudentLifeController controller;
  final ValueChanged<StudentModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final modules = [
      _ModuleData(
        title: 'Academics',
        subtitle: '${controller.dueTaskCount} tasks due',
        detail: 'Subjects, grades, deadlines',
        color: AppPalette.softRed,
        icon: Icons.auto_stories_rounded,
        module: StudentModule.academics,
      ),
      _ModuleData(
        title: 'Budget',
        subtitle: controller.weeklyBudgetLeft,
        detail: 'Spending and categories',
        color: AppPalette.softGreen,
        icon: Icons.account_balance_wallet_rounded,
        module: StudentModule.budget,
      ),
      _ModuleData(
        title: 'Chat',
        subtitle: '${controller.chatThreads.length} conversations',
        detail: 'Marketplace and direct messages',
        color: const Color(0xFFEAF2FF),
        icon: Icons.chat_bubble_rounded,
        module: StudentModule.chat,
      ),
      _ModuleData(
        title: 'Market',
        subtitle: '${controller.listings.length} listings',
        detail: 'Sell, trade, and buy',
        color: const Color(0xFFFCE7F3),
        icon: Icons.storefront_rounded,
        module: StudentModule.marketplace,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 380
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final m in modules)
              SizedBox(
                width: cardWidth,
                child: _ModuleCard(data: m, onTap: () => onOpenModule(m.module)),
              ),
          ],
        );
      },
    );
  }
}

class _ModuleData {
  const _ModuleData({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.color,
    required this.icon,
    required this.module,
  });

  final String title;
  final String subtitle;
  final String detail;
  final Color color;
  final IconData icon;
  final StudentModule module;
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.data, required this.onTap});

  final _ModuleData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: data.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(data.icon, size: 20, color: AppPalette.ink),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_rounded,
                    size: 16, color: AppPalette.muted),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppPalette.muted,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppPalette.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppPalette.muted),
          ],
        ),
      ),
    );
  }
}
