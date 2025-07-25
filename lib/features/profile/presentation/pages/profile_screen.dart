import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_text.dart'; // Assuming ProfileText is defined here

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('No user data found.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth < 600 ? double.infinity : 500,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileText(label: 'Name', value: user.name),
                  ProfileText(label: 'Email', value: user.email),
                  ProfileText(label: 'Phone', value: user.phone),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add logout logic here
                          print('Logout button pressed');
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
