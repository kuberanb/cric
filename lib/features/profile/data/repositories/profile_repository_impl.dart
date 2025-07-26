import 'package:cric/features/profile/data/datasources/remote_datasouce.dart';
import 'package:cric/features/profile/data/models/user_model.dart';
import 'package:cric/features/profile/domain/entities/user.dart';
import 'package:cric/features/profile/domain/repositories/profile_repository.dart';
import 'package:cric/features/profile/domain/usecases/logout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository, LogoutUseCase {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser(int id) async {
    final data = await remoteDataSource.fetchUser(id);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> call() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
  }
}
