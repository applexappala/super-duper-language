import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  static ShadThemeData light() {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadColorScheme(
        background: Color(0xFFFFFFFF),
        foreground: Color(0xFF0F172A),
        card: Color(0xFFFFFFFF),
        cardForeground: Color(0xFF0F172A),
        popover: Color(0xFFFFFFFF),
        popoverForeground: Color(0xFF0F172A),
        primary: Color(0xFF0F172A), // Slate 900
        primaryForeground: Color(0xFFF8FAFC),
        secondary: Color(0xFFF1F5F9), // Slate 100
        secondaryForeground: Color(0xFF0F172A),
        muted: Color(0xFFF1F5F9),
        mutedForeground: Color(0xFF64748B),
        accent: Color(0xFFF1F5F9),
        accentForeground: Color(0xFF0F172A),
        destructive: Color(0xFFEF4444),
        destructiveForeground: Color(0xFFF8FAFC),
        border: Color(0xFFE2E8F0),
        input: Color(0xFFE2E8F0),
        ring: Color(0xFF94A3B8),
        selection: Color(0xFFCBD5E1),
      ),
    );
  }

  static ShadThemeData dark() {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadColorScheme(
        background: Color(0xFF020617), // Slate 950
        foreground: Color(0xFFF8FAFC),
        card: Color(0xFF020617),
        cardForeground: Color(0xFFF8FAFC),
        popover: Color(0xFF020617),
        popoverForeground: Color(0xFFF8FAFC),
        primary: Color(0xFFF8FAFC), // Slate 50
        primaryForeground: Color(0xFF0F172A),
        secondary: Color(0xFF1E293B), // Slate 800
        secondaryForeground: Color(0xFFF8FAFC),
        muted: Color(0xFF1E293B),
        mutedForeground: Color(0xFF94A3B8),
        accent: Color(0xFF1E293B),
        accentForeground: Color(0xFFF8FAFC),
        destructive: Color(0xFF7F1D1D),
        destructiveForeground: Color(0xFFF8FAFC),
        border: Color(0xFF1E293B),
        input: Color(0xFF1E293B),
        ring: Color(0xFF475569),
        selection: Color(0xFF334155),
      ),
    );
  }
}
