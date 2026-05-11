import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';

enum _AuthView { welcome, login, signUp }

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key, required this.controller});

  final StudentLifeController controller;

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  _AuthView _view = _AuthView.welcome;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_view == _AuthView.login) {
      widget.controller.login(
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );
    } else {
      widget.controller.signUp(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return switch (_view) {
      _AuthView.welcome => _WelcomePage(
          onLogin: () => setState(() => _view = _AuthView.login),
          onRegister: () => setState(() => _view = _AuthView.signUp),
        ),
      _AuthView.login => _FormPage(
          isLogin: true,
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          passCtrl: _passCtrl,
          controller: widget.controller,
          onBack: () => setState(() => _view = _AuthView.welcome),
          onSwitchMode: () => setState(() => _view = _AuthView.signUp),
          onSubmit: _submit,
        ),
      _AuthView.signUp => _FormPage(
          isLogin: false,
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          passCtrl: _passCtrl,
          controller: widget.controller,
          onBack: () => setState(() => _view = _AuthView.welcome),
          onSwitchMode: () => setState(() => _view = _AuthView.login),
          onSubmit: _submit,
        ),
    };
  }
}

// ── Welcome Page ────────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onLogin, required this.onRegister});

  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050D1C), Color(0xFF091830), Color(0xFF0E2850)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo — white icons pop on dark bg, navy circle gives depth
                Image.asset('lib/logo/logo.png', width: 160, height: 160),
                const SizedBox(height: 36),

                // WELCOME
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Student Life OS',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Your all-in-one student companion for academics, budget, chat, and campus marketplace.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),

                const Spacer(flex: 3),

                // Log In — white filled button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppPalette.navy,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Register link
                GestureDetector(
                  onTap: onRegister,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Form Page (Login & Sign Up) ──────────────────────────────────────────────

class _FormPage extends StatelessWidget {
  const _FormPage({
    required this.isLogin,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.controller,
    required this.onBack,
    required this.onSwitchMode,
    required this.onSubmit,
  });

  final bool isLogin;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final StudentLifeController controller;
  final VoidCallback onBack;
  final VoidCallback onSwitchMode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECF2FF), Color(0xFFF4F0FF), Color(0xFFFFF4F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.navy.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppPalette.navy,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Logo centered — larger on form page
                Center(
                  child: Image.asset(
                    'lib/logo/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 18),

                // App name + subtitle
                const Center(
                  child: Text(
                    'Student Life OS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppPalette.navy,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    isLogin ? 'Sign in to your account' : 'Create a new account',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppPalette.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.navy.withValues(alpha: 0.07),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin ? 'Welcome back' : 'Get started',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppPalette.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLogin
                            ? 'Enter your credentials to continue.'
                            : 'Fill in your details to create an account.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppPalette.muted,
                          height: 1.45,
                        ),
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 20),
                        _AuthField(
                          controller: nameCtrl,
                          label: 'Full name',
                          hint: 'Enter your full name',
                          icon: Icons.person_rounded,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _AuthField(
                        controller: emailCtrl,
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.mail_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _AuthField(
                        controller: passCtrl,
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.lock_rounded,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),

                      // Gradient CTA
                      _GradientButton(
                        label: controller.isLoading
                            ? 'Please wait...'
                            : isLogin
                                ? 'Login to Dashboard'
                                : 'Create Account',
                        onTap: controller.isLoading ? null : onSubmit,
                      ),
                      const SizedBox(height: 18),

                      // Switch mode link
                      Center(
                        child: GestureDetector(
                          onTap: onSwitchMode,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: isLogin
                                      ? "Don't have an account? "
                                      : 'Already have an account? ',
                                  style: const TextStyle(
                                      color: AppPalette.muted),
                                ),
                                TextSpan(
                                  text: isLogin ? 'Sign Up' : 'Log In',
                                  style: const TextStyle(
                                    color: AppPalette.royalBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Error
                      if (controller.errorMessage != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppPalette.softRed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_rounded,
                                  color: AppPalette.brightRed, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: const TextStyle(
                                    color: AppPalette.brightRed,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppPalette.navy, AppPalette.royalBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppPalette.navy.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
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
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }
}
