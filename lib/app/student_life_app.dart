import 'package:flutter/material.dart';

import '../controllers/student_life_controller.dart';
import '../data/student_repository.dart';
import '../data/supabase_student_service.dart';
import '../navigation/student_life_shell.dart';
import '../screens/auth_gate_screen.dart';
import 'app_theme.dart';

class StudentLifeApp extends StatefulWidget {
  const StudentLifeApp({super.key});

  @override
  State<StudentLifeApp> createState() => _StudentLifeAppState();
}

class _StudentLifeAppState extends State<StudentLifeApp> {
  late final StudentLifeController controller;

  @override
  void initState() {
    super.initState();
    controller = StudentLifeController(
      StudentRepository.demo(),
      SupabaseStudentService(),
    );
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Student Life OS',
          theme: buildStudentLifeTheme(),
          home: controller.isBootstrapping
              ? const _BootstrapScreen()
              : controller.isAuthenticated
              ? StudentLifeShell(controller: controller)
              : AuthGateScreen(controller: controller),
        );
      },
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
