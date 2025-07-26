import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/theme_entity.dart';
import '../../data/models/theme_model.dart';
import '../../domain/usecases/get_current_theme.dart';
import '../../domain/usecases/set_theme.dart';
import '../../domain/usecases/toggle_theme.dart';

class ThemeController extends GetxController {
  final GetCurrentTheme getCurrentTheme;
  final SetTheme setTheme;
  final ToggleTheme toggleTheme;

  Rx<ThemeEntity> currentTheme = ThemeModel.light().obs;
  RxBool isLoading = false.obs;

  ThemeController({
    required this.getCurrentTheme,
    required this.setTheme,
    required this.toggleTheme,
  });

  @override
  void onInit() {
    super.onInit();
    loadCurrentTheme();
  }

  Future<void> loadCurrentTheme() async {
    try {
      isLoading.value = true;
      final theme = await getCurrentTheme();
      currentTheme.value = theme;
    } catch (e) {
      // Keep default theme on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeTheme(ThemeEntity theme) async {
    try {
      await setTheme(theme);
      currentTheme.value = theme;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleThemeMode() async {
    try {
      final newTheme = await toggleTheme();
      currentTheme.value = newTheme;
    } catch (e) {
      // Handle error
    }
  }

  bool get isDarkMode => currentTheme.value.isDark;
  bool get isLightMode => currentTheme.value.isLight;
}
