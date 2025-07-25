import 'package:cric/features/home/presentation/controllers/home_controller.dart';
import 'package:cric/features/login/data/repositories/login_repository_impl.dart';
import 'package:cric/features/login/domain/repositories/login_repository_impl.dart';
import 'package:cric/features/login/domain/usecases/login_usecase.dart';
import 'package:cric/features/login/presentation/controllers/login_controller.dart';

import 'package:cric/features/profile/data/datasources/remote_datasouce.dart';
import 'package:cric/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:cric/features/profile/domain/usecases/get_user.dart';
import 'package:cric/features/profile/presentation/controllers/profile_controller.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // ✅ Home controller (no dependency)
    Get.put<HomeController>(HomeController());

    // ✅ Dio instance (can be reused for REST if needed)
    final dio = Dio();

    // ✅ Login Feature Bindings
    final loginRemoteDataSource = LoginRemoteDataSourceImpl(dio);
    final loginRepository = LoginRepositoryImpl(remoteDataSource: loginRemoteDataSource);
    final loginUseCase = LoginUseCase(loginRepository);
    Get.put<LoginController>(LoginController(useCase: loginUseCase));

    // ✅ Profile Feature Bindings (GraphQL)
    final remoteDataSource = RemoteDataSource(); // from GraphQL
    final profileRepository = ProfileRepositoryImpl(remoteDataSource);
    final getUserUseCase = GetUser(profileRepository);
    Get.put<ProfileController>(ProfileController(getUserUseCase));
  }
}
