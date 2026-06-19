import 'package:flutter/material.dart';

class ShieldIcon extends StatelessWidget {
  const ShieldIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.5),
                  blurRadius: 35,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: const Color(0xFF42A5F5).withOpacity(0.25),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),
          // Shield background circle
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A3A8F),
                  Color(0xFF0D1B4B),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF2D6FD4).withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.security_rounded,
              color: Color(0xFF64B5F6),
              size: 46,
            ),
          ),
        ],
      ),
    );
  }
}
