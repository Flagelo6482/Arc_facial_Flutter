import 'package:flutter/material.dart';
import '../widgets/cyber_background.dart';
import '../widgets/shield_icon.dart';
import '../widgets/cyber_text_field.dart';
import '../widgets/cyber_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
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
              'Login',
              style: TextStyle(
                color: Color(0xFF4FC3F7),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign up or login to see what happening',
              style: TextStyle(
                color: Color(0xFF78909C),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 32),

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
            const SizedBox(height: 16),

            // Remember me + Forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        activeColor: const Color(0xFF1565C0),
                        checkColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF2D7DD2), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: Color(0xFF90A4AE), fontSize: 13),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Color(0xFF42A5F5),
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF42A5F5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Login button
            CyberButton(
              text: 'Login',
              onPressed: () {
                // TODO: implement login logic
              },
            ),
            const SizedBox(height: 28),

            // Go to Register
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Not registered yet?  ',
                    style: TextStyle(color: Color(0xFF78909C), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                    child: const Text(
                      'Create Account',
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
