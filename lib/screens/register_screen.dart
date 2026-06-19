import 'package:flutter/material.dart';
import '../widgets/cyber_background.dart';
import '../widgets/shield_icon.dart';
import '../widgets/cyber_text_field.dart';
import '../widgets/cyber_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  @override
  Widget build(BuildContext context) {
    return CyberBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Shield icon centered
            const Center(child: ShieldIcon()),
            const SizedBox(height: 32),

            // Title
            const Text(
              'Create Account',
              style: TextStyle(
                color: Color(0xFF4FC3F7),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Create an account to discover',
              style: TextStyle(
                color: Color(0xFF78909C),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            CyberTextField(
              label: 'Your Name',
              icon: Icons.person_outline,
              controller: _nameCtrl,
            ),
            const SizedBox(height: 18),

            // Email field
            CyberTextField(
              label: 'Email address',
              icon: Icons.email_outlined,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),

            // Password field
            CyberTextField(
              label: 'Password',
              icon: Icons.lock_outline,
              controller: _passCtrl,
              isPassword: true,
            ),
            const SizedBox(height: 30),

            // Create Account button
            CyberButton(
              text: 'Create Account',
              onPressed: () {
                // TODO: implement register logic
              },
            ),
            const SizedBox(height: 28),

            // Go to Login
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have an Account?  ',
                    style: TextStyle(color: Color(0xFF78909C), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF42A5F5),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF42A5F5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
