import 'package:flutter/material.dart';

import '../controllers/student_life_controller.dart';
import '../screens/academics_screen.dart';
import '../screens/announcements_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/wellness_screen.dart';
import '../widgets/student_widgets.dart';

class StudentLifeShell extends StatefulWidget {
  const StudentLifeShell({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  State<StudentLifeShell> createState() => _StudentLifeShellState();
}

class _StudentLifeShellState extends State<StudentLifeShell> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openModule(StudentModule module) {
    switch (module) {
      case StudentModule.academics:
        widget.controller.selectTab(AppTab.academics);
        return;
      case StudentModule.budget:
        widget.controller.selectTab(AppTab.budget);
        return;
      case StudentModule.chat:
        widget.controller.selectTab(AppTab.chat);
        return;
      case StudentModule.marketplace:
        widget.controller.selectTab(AppTab.marketplace);
        return;
      case StudentModule.wellness:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WellnessScreen(controller: widget.controller),
          ),
        );
        return;
      case StudentModule.projects:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProjectsScreen(controller: widget.controller),
          ),
        );
        return;
      case StudentModule.announcements:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AnnouncementsScreen(controller: widget.controller),
          ),
        );
        return;
    }
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(controller: widget.controller),
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(controller: widget.controller),
      ),
    );
  }

  Widget _currentScreen() {
    switch (widget.controller.selectedTab) {
      case AppTab.home:
        return HomeDashboardScreen(
          controller: widget.controller,
          onOpenModule: _openModule,
          onOpenProfile: _openProfile,
          onOpenSettings: _openSettings,
        );
      case AppTab.academics:
        return AcademicsScreen(controller: widget.controller, embedded: true);
      case AppTab.budget:
        return BudgetScreen(controller: widget.controller, embedded: true);
      case AppTab.chat:
        return ChatScreen(controller: widget.controller, embedded: true);
      case AppTab.marketplace:
        return MarketplaceScreen(controller: widget.controller, embedded: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen(),
      bottomNavigationBar: AppBottomNav(
        index: widget.controller.selectedTab.index,
        onChanged: (index) => widget.controller.selectTab(AppTab.values[index]),
      ),
    );
  }
}
