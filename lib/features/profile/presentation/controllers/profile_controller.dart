import 'dart:developer';

import 'package:cric/features/profile/domain/usecases/logout_usecase.dart';
import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';

class ProfileController extends GetxController {
  final GetUser getUserUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileController(this.getUserUseCase, this.logoutUseCase);

  var user = Rxn<User>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchProfile(2); // Fetch user with ID 3
    super.onInit();
  }

  void fetchProfile(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedUser = await getUserUseCase(id);
      log("fetched user data : ${fetchedUser.toJson().toString()}");
      user.value = fetchedUser;
    } catch (e) {
      errorMessage.value = 'Failed to load profile';
      log("exception caught in fetchProfile api : ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    Get.offAllNamed('/login'); // Make sure this route is defined in your routes
  }
}
