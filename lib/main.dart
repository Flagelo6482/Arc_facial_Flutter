import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  static const _bgColor = Color(0xFF080818);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),
        // Evita el fondo blanco en cualquier Scaffold sin color definido
        scaffoldBackgroundColor: _bgColor,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        Widget page;
        Offset slideFrom;

        switch (settings.name) {
          case '/register':
            page = const RegisterScreen();
            slideFrom = const Offset(1.0, 0.0);
            break;
          case '/login':
          default:
            page = const LoginScreen();
            slideFrom = const Offset(-1.0, 0.0);
            break;
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Pantalla entrante: desliza + escala sutil + fade
            final slide = Tween<Offset>(
              begin: slideFrom,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            ));

            final scale = Tween<double>(begin: 0.94, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              ),
            );

            // Container con fondo oscuro elimina el espacio en blanco
            return Container(
              color: _bgColor,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(
                  scale: scale,
                  child: FadeTransition(opacity: fadeIn, child: child),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
