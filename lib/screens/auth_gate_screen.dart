import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({
    super.key,
    required this.controller,
  });

  final StudentLifeController controller;

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool showLogin = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: 'andrea@student.nu.edu.ph');
  final passwordController = TextEditingController(text: 'studentlifeos');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (showLogin) {
      widget.controller.login(
        email: emailController.text,
        password: passwordController.text,
      );
    } else {
      widget.controller.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F9FF), Color(0xFFFFF4F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPalette.navy, AppPalette.royalBlue, AppPalette.brightRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Life OS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'One student account for academics, wellness, budget, chat, projects, and marketplace tools.',
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _AuthTabButton(
                        label: 'Login',
                        selected: showLogin,
                        onTap: () => setState(() => showLogin = true),
                      ),
                    ),
                    Expanded(
                      child: _AuthTabButton(
                        label: 'Sign Up',
                        selected: !showLogin,
                        onTap: () => setState(() => showLogin = false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.navy.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showLogin ? 'Welcome back' : 'Create your student account',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      showLogin
                          ? 'Login before accessing your dashboard and campus tools.'
                          : 'Sign up with your student details to start using the system.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppPalette.muted,
                            height: 1.4,
                          ),
                    ),
                    if (!showLogin) ...[
                      const SizedBox(height: 18),
                      _AuthField(
                        controller: nameController,
                        label: 'Full name',
                        hint: 'Andrea Santos',
                        icon: Icons.person_rounded,
                      ),
                    ],
                    const SizedBox(height: 18),
                    _AuthField(
                      controller: emailController,
                      label: 'Email',
                      hint: 'name@student.nu.edu.ph',
                      icon: Icons.mail_rounded,
                    ),
                    const SizedBox(height: 16),
                    _AuthField(
                      controller: passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: widget.controller.isLoading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppPalette.deepNav,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          widget.controller.isLoading
                              ? 'Please wait...'
                              : showLogin
                                  ? 'Login to Dashboard'
                                  : 'Create Account',
                        ),
                      ),
                    ),
                    if (widget.controller.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.controller.errorMessage!,
                        style: const TextStyle(
                          color: AppPalette.brightRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Text(
                      'Demo mode: use the prefilled credentials or create a quick mock account.',
                      style: TextStyle(color: AppPalette.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
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
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      ],
    );
  }
}

class _AuthTabButton extends StatelessWidget {
  const _AuthTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppPalette.deepNav : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : AppPalette.ink,
          ),
        ),
      ),
    );
  }
}
