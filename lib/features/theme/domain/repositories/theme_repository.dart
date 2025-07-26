import '../entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<ThemeEntity> getCurrentTheme();
  Future<void> setTheme(ThemeEntity theme);
  Future<ThemeEntity> toggleTheme();
} 