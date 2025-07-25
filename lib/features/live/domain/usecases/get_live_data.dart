
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/live/domain/repositories/live_repository.dart';

class GetLiveData {
  final LiveRepository repository;
  GetLiveData(this.repository);

  Future<LiveDataModel> call() => repository.getLiveData();
}
