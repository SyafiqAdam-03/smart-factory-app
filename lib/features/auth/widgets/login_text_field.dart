import 'package:flutter/material.dart';
import 'package:smart_factory_qc/core/constants/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_spacing.dart';

/// Small all-caps label (e.g. "SIGN IN TO PLANT 01").
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.text, {
    super.key,
    this.color = AppColors.slate600,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color,
      ),
    );
  }
}

/// Label that sits directly above a form field (e.g. "WORK EMAIL").
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      SectionLabel(text, color: AppColors.slate700);
}

/// Flat outlined text field: 1px border, 2px accent border on focus.
class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.suffixIcon,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final Widget suffixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      autocorrect: false,
      enableSuggestions: !obscureText,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppColors.navy,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 16),
        filled: true,
        fillColor: AppColors.white,
        constraints: const BoxConstraints(minHeight: AppSpacing.x7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        suffixIcon: suffixIcon,
        border: _border(AppColors.slate300),
        enabledBorder: _border(AppColors.slate300),
        disabledBorder: _border(AppColors.slate200),
        focusedBorder: _border(AppColors.accent, 2),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, 2),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 13),
      ),
    );
  }
}