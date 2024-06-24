import 'package:flutter/material.dart';

class InnerGradientIcon extends StatelessWidget {
  const InnerGradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon({Key? key, required this.icon, required this.size})
      : super(key: key);

  final IconData icon;
  final double size;
  @override
  Widget build(BuildContext context) {
    return InnerGradientIcon(
      icon,
      size,
      const LinearGradient(
        colors: <Color>[
          // Color.fromARGB(255, 165, 121, 247),
          // Color.fromARGB(255, 179, 225, 255),
          // Color.fromARGB(255, 250, 103, 243),
          // Color.fromARGB(255, 111, 47, 231),
          // Color.fromARGB(255, 121, 144, 248),
          Color.fromARGB(255, 157, 251, 160),
          Color.fromARGB(255, 29, 201, 192),
          // Color.fromARGB(255, 9, 75, 11),
          Color.fromARGB(255, 182, 244, 211),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
