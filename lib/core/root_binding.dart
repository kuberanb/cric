import 'package:cric/features/live/data/datasources/live_remote_data_source.dart';
import 'package:cric/features/login/domain/repositories/login_repository_impl.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

// ✅ Home
import 'package:cric/features/home/presentation/controllers/home_controller.dart';

// ✅ Login
import 'package:cric/features/login/data/repositories/login_repository_impl.dart';
import 'package:cric/features/login/domain/usecases/login_usecase.dart';
import 'package:cric/features/login/presentation/controllers/login_controller.dart';

// ✅ Profile (GraphQL)
import 'package:cric/features/profile/data/datasources/remote_datasouce.dart';
import 'package:cric/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:cric/features/profile/domain/usecases/get_user.dart';
import 'package:cric/features/profile/presentation/controllers/profile_controller.dart';

// ✅ Live Feature
import 'package:cric/features/live/data/repositories/live_repository_impl.dart';
import 'package:cric/features/live/domain/usecases/get_live_data.dart';
import 'package:cric/features/live/presentation/controllers/live_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // ✅ Dio (shared instance)
    final dio = Dio();

    // ✅ Home
    Get.put<HomeController>(HomeController());

    // ✅ Login
    final loginRemoteDataSource = LoginRemoteDataSourceImpl(dio);
    final loginRepository = LoginRepositoryImpl(remoteDataSource: loginRemoteDataSource);
    final loginUseCase = LoginUseCase(loginRepository);
    Get.put<LoginController>(LoginController(useCase: loginUseCase));

    // ✅ Profile (GraphQL)
    final remoteDataSource = RemoteDataSource();
    final profileRepository = ProfileRepositoryImpl(remoteDataSource);
    final getUserUseCase = GetUser(profileRepository);
    Get.put<ProfileController>(ProfileController(getUserUseCase));

    // ✅ Live Matches
    final liveRemoteDataSource = LiveRemoteDataSourceImpl(dio);
    final liveRepository = LiveRepositoryImpl(liveRemoteDataSource);
    final getLiveDataUseCase = GetLiveData(liveRepository);
    Get.put<LiveController>(LiveController(getLiveDataUseCase: getLiveDataUseCase));
  }
}
