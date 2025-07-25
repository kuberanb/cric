


import 'package:cric/features/profile/data/datasources/remote_datasouce.dart';
import 'package:cric/features/profile/data/models/user_model.dart';
import 'package:cric/features/profile/domain/entities/user.dart';
import 'package:cric/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser(int id) async {
    final data = await remoteDataSource.fetchUser(id);
    return UserModel.fromJson(data);
  }
}
