import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key, required this.startSequence});

  final Future<void> Function() startSequence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: key,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _buildGlassButton(
            "Let's get started",
            1,
            startSequence,
            isPrimary: true,
          ),
          // InkWell(
          //   onTap: startSequence,
          //   child: Container(
          //     height: 100,
          //     width: 340,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //       border: BoxBorder.all(
          //         color: Colors.white,
          //         width: 1,
          //         style: BorderStyle.solid,
          //       ),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Let's get started",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 36,
          //           fontWeight: FontWeight.bold,
          //           letterSpacing: 1.2,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

Widget _buildGlassButton(
  String text,
  double glow,
  VoidCallback onTap, {
  bool isPrimary = false,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    Color.lerp(
                      Colors.white.withValues(alpha: 0.12),
                      const Color(0xFFFFD48A).withValues(alpha: 0.3),
                      glow,
                    )!,
                    Color.lerp(
                      Colors.white.withValues(alpha: 0.06),
                      const Color(0xFFFFA726).withValues(alpha: 0.15),
                      glow,
                    )!,
                  ],
                )
              : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isPrimary
                ? Color.lerp(
                    Colors.white.withValues(alpha: 0.2),
                    const Color(0xFFFFD48A).withValues(alpha: 0.5),
                    glow,
                  )!
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary
                ? Color.lerp(Colors.white70, const Color(0xFFFFE8C0), glow)
                : Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    ),
  );
}
