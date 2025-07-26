import 'package:cric/features/login/domain/repositories/login_repository_impl.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'package:cric/features/profile/domain/usecases/logout_usecase.dart';
import 'package:cric/features/profile/presentation/controllers/profile_controller.dart';

// ✅ Live Matches
import 'package:cric/features/live/data/datasources/live_remote_data_source.dart';
import 'package:cric/features/live/data/repositories/live_repository_impl.dart';
import 'package:cric/features/live/domain/usecases/get_live_data.dart';
import 'package:cric/features/live/presentation/controllers/live_controller.dart';

// ✅ Theme
import 'package:cric/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:cric/features/theme/domain/usecases/get_current_theme.dart';
import 'package:cric/features/theme/domain/usecases/set_theme.dart';
import 'package:cric/features/theme/domain/usecases/toggle_theme.dart';
import 'package:cric/features/theme/presentation/controllers/theme_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // ✅ Shared Dio instance
    final dio = Dio();

    // ✅ Home Controller
    Get.put<HomeController>(HomeController());

    // ✅ Login Setup
    final loginRemoteDataSource = LoginRemoteDataSourceImpl(dio);
    final loginRepository = LoginRepositoryImpl(
      remoteDataSource: loginRemoteDataSource,
    );
    final loginUseCase = LoginUseCase(loginRepository);
    Get.put<LoginController>(LoginController(useCase: loginUseCase));

    // ✅ Profile Setup (with Logout inside repository)
    final profileRemoteDataSource = RemoteDataSource();
    final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);
    final getUserUseCase = GetUser(profileRepository);
    // LogoutUseCase is also implemented in ProfileRepositoryImpl
    Get.put<ProfileController>(
      ProfileController(getUserUseCase, profileRepository),
    );

    // ✅ Live Match Setup
    final liveRemoteDataSource = LiveRemoteDataSourceImpl(dio);
    final liveRepository = LiveRepositoryImpl(liveRemoteDataSource);
    final getLiveDataUseCase = GetLiveData(liveRepository);
    Get.put<LiveController>(
      LiveController(getLiveDataUseCase: getLiveDataUseCase),
    );

    // ✅ Theme Setup
    final themeRepository = ThemeRepositoryImpl();
    final getCurrentTheme = GetCurrentTheme(themeRepository);
    final setTheme = SetTheme(themeRepository);
    final toggleTheme = ToggleTheme(themeRepository);
    Get.put<ThemeController>(
      ThemeController(
        getCurrentTheme: getCurrentTheme,
        setTheme: setTheme,
        toggleTheme: toggleTheme,
      ),
    );
  }
}
