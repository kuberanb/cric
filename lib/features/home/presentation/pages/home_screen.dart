import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'live_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class HomeScreen extends GetView<HomeController> {
  final List<Widget> screens = [LiveScreen(), ProfileScreen()];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
