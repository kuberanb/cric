import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';
import '../models/theme_model.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeKey = 'app_theme';

  @override
  Future<ThemeEntity> getCurrentTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeJson = prefs.getString(_themeKey);
      
      if (themeJson != null) {
        final themeMap = jsonDecode(themeJson) as Map<String, dynamic>;
        return ThemeModel.fromJson(themeMap);
      }
      
      // Default to light theme
      return ThemeModel.light();
    } catch (e) {
      // Return light theme as fallback
      return ThemeModel.light();
    }
  }

  @override
  Future<void> setTheme(ThemeEntity theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModel = ThemeModel(
        mode: theme.mode,
        name: theme.name,
        description: theme.description,
      );
      
      final themeJson = jsonEncode(themeModel.toJson());
      await prefs.setString(_themeKey, themeJson);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<ThemeEntity> toggleTheme() async {
    final currentTheme = await getCurrentTheme();
    final newTheme = currentTheme.isLight 
        ? ThemeModel.dark() 
        : ThemeModel.light();
    
    await setTheme(newTheme);
    return newTheme;
  }
} 