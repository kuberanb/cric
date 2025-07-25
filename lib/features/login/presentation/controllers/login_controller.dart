import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase useCase;

  LoginController({required this.useCase});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var isCheckingAuth = true.obs; // for splash/loading screen

  var isAuthenticated = false.obs; // For deciding which screen to show

  Future<void> checkAuthAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    log("fetched token : $token");

    if (token != null && token.isNotEmpty) {
      isAuthenticated.value = true;
    }

    isCheckingAuth.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }


  void login() async {
    emailController.text = "eve.holt@reqres.in";
    passwordController.text = "cityslicka";

    if (!formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();

    isLoading.value = true;

    try {
      final token = await useCase(
        emailController.text,
        passwordController.text,
      );
      Get.snackbar(
        'Login Successful',
        'Token: $token',
        snackPosition: SnackPosition.BOTTOM,
      );
      // ✅ Save token to SharedPreferences
      await prefs.setString('auth_token', token);

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
