import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController campusController;
  late final TextEditingController programController;
  late final TextEditingController yearController;
  late final TextEditingController studentIdController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.profile;
    nameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    campusController = TextEditingController(text: profile.campus);
    programController = TextEditingController(text: profile.program);
    yearController = TextEditingController(text: profile.yearLevel);
    studentIdController = TextEditingController(text: profile.studentId);
    bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    campusController.dispose();
    programController.dispose();
    yearController.dispose();
    studentIdController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    await widget.controller.updateProfile(
      UserProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        campus: campusController.text.trim(),
        program: programController.text.trim(),
        yearLevel: yearController.text.trim(),
        studentId: studentIdController.text.trim(),
        greeting: 'Student Life OS dashboard',
        bio: bioController.text.trim(),
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModulePageScaffold(
      title: 'Profile Configuration',
      subtitle: 'Keep your academic identity, basic student details, and public marketplace profile updated.',
      accent: AppPalette.navy,
      body: [
        InfoCard(
          child: Column(
            children: [
              _profileField('Full name', nameController),
              const SizedBox(height: 14),
              _profileField('Email', emailController),
              const SizedBox(height: 14),
              _profileField('Campus', campusController),
              const SizedBox(height: 14),
              _profileField('Program', programController),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _profileField('Year level', yearController)),
                  const SizedBox(width: 12),
                  Expanded(child: _profileField('Student ID', studentIdController)),
                ],
              ),
              const SizedBox(height: 14),
              _profileField('Short bio', bioController, maxLines: 3),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveProfile,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPalette.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
