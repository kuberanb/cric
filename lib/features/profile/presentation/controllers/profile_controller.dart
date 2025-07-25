import 'dart:developer';

import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';

class ProfileController extends GetxController {
  final GetUser getUserUseCase;

  ProfileController(this.getUserUseCase);

  var user = Rxn<User>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchProfile(3); // Fetch user with ID 3
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
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
