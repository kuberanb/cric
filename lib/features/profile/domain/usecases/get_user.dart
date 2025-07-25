
import 'package:cric/features/profile/domain/repositories/profile_repository.dart';

import '../entities/user.dart';

class GetUser {
  final ProfileRepository repository;

  GetUser(this.repository);

  Future<User> call(int id) {
    return repository.getUser(id);
  }
}
