import 'package:flutter/material.dart';

/// A customizable card widget with elevation and rounded corners.
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.style,
    this.border, // Added border property
  });

  final Widget child;
  final dynamic style;
  final BoxBorder? border; // Added border property

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: border, // Use the provided border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A small badge widget to display short information.
class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    required this.text,
    this.color = const Color(0xFF6B7280),
    this.bg = const Color(0xFFF3F4F6),
  });

  final String text;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A primary button with solid and outline styles.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPress,
    this.icon,
    this.outline = false,
  });

  final String title;
  final VoidCallback? onPress;
  final IconData? icon;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    final textColor = outline ? const Color(0xFFEF4444) : Colors.white;
    final backgroundColor =
        outline ? Colors.transparent : const Color(0xFFEF4444);
    final borderColor =
        outline ? const Color(0xFFEF4444) : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: outline
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: textColor,
                ),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
