enum ThemeMode {
  light,
  dark,
}

class ThemeEntity {
  final ThemeMode mode;
  final String name;
  final String description;

  const ThemeEntity({
    required this.mode,
    required this.name,
    required this.description,
  });

  bool get isDark => mode == ThemeMode.dark;
  bool get isLight => mode == ThemeMode.light;
} 