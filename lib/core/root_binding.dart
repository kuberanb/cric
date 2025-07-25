import 'package:cric/features/home/presentation/controllers/home_controller.dart';
import 'package:cric/features/login/data/repositories/login_repository_impl.dart';
import 'package:cric/features/login/domain/repositories/login_repository_impl.dart';
import 'package:cric/features/login/domain/usecases/login_usecase.dart';
import 'package:cric/features/login/presentation/controllers/login_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // ✅ Home controller (no dependency)
    Get.put<HomeController>(HomeController());

    // ✅ Create Dio instance
    final dio = Dio();

    // ✅ Data Source
    final remoteDataSource = LoginRemoteDataSourceImpl(dio);

    // ✅ Repository
    final loginRepository = LoginRepositoryImpl(remoteDataSource: remoteDataSource);

    // ✅ Use Case
    final loginUseCase = LoginUseCase(loginRepository);

    // ✅ Inject LoginController with UseCase
    Get.put<LoginController>(LoginController(useCase: loginUseCase));
  }
}
