import 'package:cric/features/login/data/datasources/login_remote_datasource.dart';

import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
}
