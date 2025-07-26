import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

class GetCurrentTheme {
  final ThemeRepository repository;

  GetCurrentTheme(this.repository);

  Future<ThemeEntity> call() async {
    return await repository.getCurrentTheme();
  }
} 