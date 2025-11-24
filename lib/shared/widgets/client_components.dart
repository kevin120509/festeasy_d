import 'package:flutter/material.dart';

/// A button with a stadium/pill shape, supporting filled and outline styles.
class ClientButton extends StatelessWidget {
  const ClientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutline = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ), // Increased horizontal padding
        minimumSize: const Size.fromHeight(55), // Increased minimum height
        shape: const StadiumBorder(),
        backgroundColor: isOutline
            ? Colors.transparent
            : const Color(0xFFEF4444),
        foregroundColor: isOutline ? const Color(0xFFEF4444) : Colors.white,
        elevation: isOutline ? 0 : 2,
        side: isOutline
            ? const BorderSide(color: Color(0xFFEF4444), width: 2)
            : null,
      ),
      child: Text(
        text,
        maxLines: 1, // Ensure text does not wrap
        overflow:
            TextOverflow.ellipsis, // Truncate with ellipsis if text is too long
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

/// A modern text input field with a light gray background and rounded corners, without an explicit label above it.
class ModernInput extends StatelessWidget {
  const ModernInput({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.controller,
  });

  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF9CA3AF))
            : null,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}

/// A widget combining a label and a styled TextFormField, with an optional icon.
class InputGroup extends StatelessWidget {
  const InputGroup({
    super.key,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFF9CA3AF))
                : null,
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// A square card with an icon and text, typically used in a grid.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.iconColor,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
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
