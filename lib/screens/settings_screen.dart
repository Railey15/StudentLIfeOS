import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late StudentSettings settings;

  @override
  void initState() {
    super.initState();
    settings = widget.controller.settings;
  }

  Future<void> _save() async {
    await widget.controller.updateSettings(settings);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModulePageScaffold(
      title: 'Settings',
      subtitle: 'Control notifications, privacy, security, and session preferences for the whole app.',
      accent: AppPalette.brightRed,
      body: [
        InfoCard(
          child: Column(
            children: [
              _settingTile(
                title: 'Push notifications',
                subtitle: 'Announcements, reminders, and school updates',
                value: settings.pushNotifications,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(pushNotifications: value),
                ),
              ),
              _settingTile(
                title: 'Deadline reminders',
                subtitle: 'Academic tasks and group project due dates',
                value: settings.deadlineReminders,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(deadlineReminders: value),
                ),
              ),
              _settingTile(
                title: 'Marketplace messages',
                subtitle: 'Message alerts from buyers and sellers',
                value: settings.marketplaceMessages,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(marketplaceMessages: value),
                ),
              ),
              _settingTile(
                title: 'Biometric lock',
                subtitle: 'Require fingerprint or face unlock for the app',
                value: settings.biometricLock,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(biometricLock: value),
                ),
              ),
              _settingTile(
                title: 'Dark mode preference',
                subtitle: 'Stored for future theme switching support',
                value: settings.darkMode,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(darkMode: value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.brightRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Save Settings'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              widget.controller.logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.deepNav,
              side: const BorderSide(color: AppPalette.deepNav),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _settingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppPalette.muted),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
