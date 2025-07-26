import '../../domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  const ThemeModel({
    required super.mode,
    required super.name,
    required super.description,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      mode: ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${json['mode']}',
        orElse: () => ThemeMode.light,
      ),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.toString().split('.').last,
      'name': name,
      'description': description,
    };
  }

  factory ThemeModel.light() {
    return const ThemeModel(
      mode: ThemeMode.light,
      name: 'Light Mode',
      description: 'Bright theme for daytime use',
    );
  }

  factory ThemeModel.dark() {
    return const ThemeModel(
      mode: ThemeMode.dark,
      name: 'Dark Mode',
      description: 'Dark theme for nighttime use',
    );
  }
} 