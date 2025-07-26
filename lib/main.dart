import 'package:cric/core/root_binding.dart';
import 'package:cric/core/simple_background_handler.dart';
import 'package:cric/core/theme_service.dart';
import 'package:cric/features/home/presentation/pages/home_screen.dart';
import 'package:cric/features/login/presentation/controllers/login_controller.dart';
import 'package:cric/features/login/presentation/screens/login_screen.dart';
import 'package:cric/features/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize background handler
  await SimpleBackgroundHandler.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: RootBinding(),
      theme: AppThemeService.getLightTheme(),
      darkTheme: AppThemeService.getDarkTheme(),
      builder: (context, child) {
        // Safe to access controller here
        final themeController = Get.find<ThemeController>();
        return Obx(() {
          return MaterialApp(
            theme: AppThemeService.getLightTheme(),
            darkTheme: AppThemeService.getDarkTheme(),
            themeMode: themeController.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: child,
          );
        });
      },
      home: Obx(() {
        final loginController = Get.find<LoginController>();

        if (loginController.isCheckingAuth.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return loginController.isAuthenticated.value
            ? HomeScreen()
            : LoginView();
      }),
      getPages: [GetPage(name: '/login', page: () => LoginView())],
    );
  }
}
