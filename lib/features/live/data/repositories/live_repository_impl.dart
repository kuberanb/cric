
import 'package:cric/features/live/data/datasources/live_remote_data_source.dart';
import 'package:cric/features/live/data/models/live_data_model.dart';

import '../../domain/repositories/live_repository.dart';

class LiveRepositoryImpl implements LiveRepository {
  final LiveRemoteDataSource remoteDataSource;
  LiveRepositoryImpl(this.remoteDataSource);

  @override
  Future<LiveDataModel> getLiveData() {
    return remoteDataSource.fetchLiveData();
  }
}
